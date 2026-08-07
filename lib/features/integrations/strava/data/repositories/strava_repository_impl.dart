import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import '../../domain/entities/strava_activity.dart';
import '../../domain/entities/strava_auth_state.dart';
import '../../domain/repositories/i_strava_repository.dart';
import '../../domain/services/i_strava_auth_service.dart';
import '../datasources/strava_api_client.dart';
import '../models/strava_activity_model.dart';
import '../../../domain/entities/integration.dart';
import '../../../domain/repositories/i_integration_repository.dart';

class StravaRepositoryImpl implements IStravaRepository {
  final Isar _isar;
  final IStravaAuthService _authService;
  final StravaApiClient _apiClient;
  final IIntegrationRepository _integrationRepo;

  StravaRepositoryImpl({
    required Isar isar,
    required IStravaAuthService authService,
    required StravaApiClient apiClient,
    required IIntegrationRepository integrationRepo,
  })  : _isar = isar,
        _authService = authService,
        _apiClient = apiClient,
        _integrationRepo = integrationRepo;

  @override
  Future<List<StravaActivity>> getActivities() async {
    final models = await _isar.stravaActivityModels.where().sortByStartDateDesc().findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<StravaActivity>> getActivitiesForDateRange(DateTime start, DateTime end) async {
    final models = await _isar.stravaActivityModels
        .filter()
        .startDateGreaterThan(start.subtract(const Duration(milliseconds: 1)))
        .and()
        .startDateLessThan(end.add(const Duration(milliseconds: 1)))
        .sortByStartDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<StravaActivity>> watchActivities() {
    return _isar.stravaActivityModels
        .where()
        .watch()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }


  @override
  Future<int> syncActivities() async {
    final token = await _authService.getValidToken();
    if (token == null) {
      await _updateIntegrationStatus(IntegrationStatus.notConnected);
      return 0;
    }

    await _updateIntegrationStatus(IntegrationStatus.syncing);

    try {
      // Find latest stored activity for incremental sync
      final latestModel = await _isar.stravaActivityModels.where().sortByStartDateDesc().findFirst();
      int? afterEpoch;
      if (latestModel != null) {
        // Safe 1 hour overlap buffer to avoid missing activities recorded close to sync boundaries
        afterEpoch = latestModel.startDate.subtract(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
      }

      int page = 1;
      const perPage = 50;
      bool hasMore = true;
      int syncedCount = 0;
      final now = DateTime.now();

      while (hasMore) {
        final dtos = await _apiClient.getActivities(
          accessToken: token.accessToken,
          after: afterEpoch,
          page: page,
          perPage: perPage,
        );

        if (dtos.isEmpty) {
          hasMore = false;
          break;
        }

        final entities = dtos.map((dto) => dto.toEntity(syncedAt: now)).toList();
        final models = entities.map(StravaActivityModel.fromEntity).toList();

        await _isar.writeTxn(() async {
          await _isar.stravaActivityModels.putAll(models);
        });

        syncedCount += dtos.length;
        if (dtos.length < perPage) {
          hasMore = false;
        } else {
          page++;
        }
      }

      final totalCount = await _isar.stravaActivityModels.count();
      await _updateIntegrationStatus(
        IntegrationStatus.connected,
        lastSync: now,
        athleteName: token.athleteName,
        activityCount: totalCount,
      );

      return syncedCount;
    } catch (e) {
      debugPrint('[STRAVA_REPO] Sync failed: $e');
      final token = await _authService.getValidToken();
      if (token != null) {
        // If we have a valid token, we are still "connected" but in an error state for the sync
        await _updateIntegrationStatus(
          IntegrationStatus.connected,
          errorMessage: 'Sync failed: $e',
        );
      } else {
        await _updateIntegrationStatus(
          IntegrationStatus.error,
          errorMessage: e.toString(),
        );
      }
      rethrow;
    }
  }

  @override
  Future<StravaAuthState> getIntegrationState() async {
    final integration = await _integrationRepo.getIntegrationById('strava');
    return _mapIntegrationToAuthState(integration);
  }

  @override
  Stream<StravaAuthState> watchIntegrationState() {
    return _integrationRepo.watchIntegrations().map((integrations) {
      final matches = integrations.where((i) => i.id == 'strava');
      if (matches.isEmpty) return const StravaAuthState();
      return _mapIntegrationToAuthState(matches.first);
    });
  }

  @override
  Future<void> disconnect() async {
    await _authService.disconnect();
    await _updateIntegrationStatus(IntegrationStatus.notConnected, activityCount: 0);
  }

  StravaAuthState _mapIntegrationToAuthState(Integration? integration) {
    if (integration == null) return const StravaAuthState();

    StravaConnectionStatus status;
    switch (integration.status) {
      case IntegrationStatus.connected:
        status = StravaConnectionStatus.connected;
        break;
      case IntegrationStatus.syncing:
        status = StravaConnectionStatus.syncing;
        break;
      case IntegrationStatus.error:
        status = StravaConnectionStatus.error;
        break;
      case IntegrationStatus.notConnected:
        status = StravaConnectionStatus.notConnected;
        break;
    }

    final metadata = integration.metadata;
    final athleteName = metadata['athleteName'] as String?;
    final activityCount = (metadata['activityCount'] as num?)?.toInt() ?? 0;
    final errorMessage = metadata['errorMessage'] as String?;

    return StravaAuthState(
      status: status,
      athleteName: athleteName,
      activityCount: activityCount,
      lastSyncedAt: integration.lastSync,
      errorMessage: errorMessage,
    );
  }

  Future<void> _updateIntegrationStatus(
    IntegrationStatus status, {
    DateTime? lastSync,
    String? athleteName,
    int? activityCount,
    String? errorMessage,
  }) async {
    final existing = await _integrationRepo.getIntegrationById('strava');
    final metadata = Map<String, dynamic>.from(existing?.metadata ?? {});

    if (athleteName != null) metadata['athleteName'] = athleteName;
    if (activityCount != null) metadata['activityCount'] = activityCount;
    if (errorMessage != null) {
      metadata['errorMessage'] = errorMessage;
    } else if (status != IntegrationStatus.error) {
      metadata.remove('errorMessage');
    }

    final updated = Integration(
      id: 'strava',
      name: 'Strava',
      status: status,
      lastSync: lastSync ?? existing?.lastSync,
      metadata: metadata,
      isSupported: true,
    );

    await _integrationRepo.updateIntegration(updated);
  }
}
