import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:orbit_v2/shared/providers/repository_providers.dart';
import 'package:orbit_v2/features/integrations/presentation/providers/integration_providers.dart';
import 'package:orbit_v2/features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../domain/entities/strava_activity.dart';
import '../../domain/entities/strava_auth_state.dart';
import '../../domain/repositories/i_strava_repository.dart';
import '../../domain/services/i_strava_auth_service.dart';
import '../../domain/services/i_strava_token_storage.dart';
import '../../domain/services/strava_analytics_adapter.dart';
import '../../data/datasources/strava_api_client.dart';
import '../../data/datasources/strava_token_storage_impl.dart';
import '../../data/services/strava_auth_service_impl.dart';
import '../../data/repositories/strava_repository_impl.dart';

final stravaTokenStorageProvider = Provider<IStravaTokenStorage>((ref) {
  return StravaTokenStorageImpl();
});

final stravaAuthServiceProvider = Provider<IStravaAuthService>((ref) {
  return StravaAuthServiceImpl(
    tokenStorage: ref.watch(stravaTokenStorageProvider),
  );
});

final stravaApiClientProvider = Provider<StravaApiClient>((ref) {
  return StravaApiClient();
});

final stravaRepositoryProvider = Provider<IStravaRepository>((ref) {
  return StravaRepositoryImpl(
    isar: ref.watch(isarProvider),
    authService: ref.watch(stravaAuthServiceProvider),
    apiClient: ref.watch(stravaApiClientProvider),
    integrationRepo: ref.watch(integrationRepositoryProvider),
  );
});

final stravaAnalyticsAdapterProvider = Provider<StravaAnalyticsAdapter>((ref) {
  return StravaAnalyticsAdapter(ref.watch(stravaRepositoryProvider));
});

final stravaAuthStateStreamProvider = StreamProvider<StravaAuthState>((ref) {
  final repo = ref.watch(stravaRepositoryProvider);
  return repo.watchIntegrationState();
});

final stravaActivitiesProvider = FutureProvider<List<StravaActivity>>((ref) async {
  final repo = ref.watch(stravaRepositoryProvider);
  return await repo.getActivities();
});

class StravaAuthNotifier extends Notifier<void> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void build() {
    _appLinks = AppLinks();
    _initDeepLinkListener();
    ref.onDispose(() => _linkSubscription?.cancel());
  }

  Future<void> _initDeepLinkListener() async {
    // Handle initial link if app was closed
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('[STRAVA_AUTH] Handling initial deep link: $initialUri');
        _processUri(initialUri);
      }
    } catch (e) {
      debugPrint('[STRAVA_AUTH] Error getting initial link: $e');
    }

    // Handle subsequent links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('[STRAVA_AUTH] Received stream deep link: $uri');
      _processUri(uri);
    }, onError: (err) {
      debugPrint('[STRAVA_AUTH] Deep link stream error: $err');
    });
  }

  void _processUri(Uri uri) {
    if (uri.scheme == 'orbit' && uri.host == 'strava-auth') {
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      
      if (code != null) {
        _handleAuthCode(code);
      } else if (error != null) {
        debugPrint('[STRAVA_AUTH] Authorization error from redirect: $error');
      }
    }
  }

  Future<void> connect() async {
    final authService = ref.read(stravaAuthServiceProvider);
    final authUrl = authService.getAuthorizationUrl();
    
    debugPrint('[STRAVA_AUTH] Launching authorization URL: $authUrl');
    
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw StravaAuthException('Could not launch Strava authorization page');
    }
  }

  Future<void> _handleAuthCode(String code) async {
    debugPrint('[STRAVA_AUTH] Exchanging code for tokens...');
    try {
      final authService = ref.read(stravaAuthServiceProvider);
      await authService.authenticateWithCode(code);
      debugPrint('[STRAVA_AUTH] Token exchange successful');

      // Refresh integration state and start initial sync
      ref.invalidate(stravaAuthStateStreamProvider);
      
      debugPrint('[STRAVA_AUTH] Starting initial activities sync...');
      await ref.read(stravaSyncNotifierProvider.notifier).sync();
      
      // Invalidate dashboard to show new data
      ref.invalidate(dashboardProvider);
    } catch (e) {
      debugPrint('[STRAVA_AUTH] ERR failed to complete connection: $e');
    }
  }
}

final stravaAuthNotifierProvider = NotifierProvider<StravaAuthNotifier, void>(() {
  return StravaAuthNotifier();
});

class StravaSyncNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<int> sync() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(stravaRepositoryProvider);
      final count = await repo.syncActivities();
      ref.invalidate(stravaActivitiesProvider);
      state = const AsyncValue.data(null);
      return count;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(stravaRepositoryProvider);
      await repo.disconnect();
      ref.invalidate(stravaActivitiesProvider);
      ref.invalidate(stravaAuthStateStreamProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final stravaSyncNotifierProvider = AsyncNotifierProvider<StravaSyncNotifier, void>(() {
  return StravaSyncNotifier();
});
