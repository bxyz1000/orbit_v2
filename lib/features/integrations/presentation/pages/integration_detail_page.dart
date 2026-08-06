import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/integration.dart';
import '../providers/integration_providers.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../core/theme/orbit_radius.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';
import '../../../health/presentation/providers/health_providers.dart';
import '../../../../features/score/presentation/providers/score_providers.dart';

class IntegrationDetailPage extends ConsumerWidget {
  final String integrationId;

  const IntegrationDetailPage({
    super.key,
    required this.integrationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final integrationAsync = ref.watch(integrationByIdProvider(integrationId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integration Details'),
      ),
      body: integrationAsync.when(
        data: (integration) {
          if (integration == null) {
            return const Center(child: Text('Integration not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(OrbitSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, colorScheme, integration),
                OrbitSpacing.gapXl,
                _buildStatusCard(theme, colorScheme, integration),
                OrbitSpacing.gapXl,
                if (integration.id == 'health_connect') 
                  _buildHealthConnectDetails(theme, colorScheme, integration)
                else if (integration.id == 'strava')
                  _buildStravaDetails(theme, colorScheme, integration),
                OrbitSpacing.gapXl,
                _buildActions(context, ref, theme, colorScheme, integration),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme, Integration integration) {
    return Center(
      child: Column(
        children: [
          _buildIcon(colorScheme),
          OrbitSpacing.gapMd,
          Text(
            integration.name,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (integration.status == IntegrationStatus.connected)
             Padding(
               padding: const EdgeInsets.only(top: 4),
               child: Text(
                 'Connected since ${_formatDate(integration.lastSync ?? DateTime.now())}',
                 style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
               ),
             ),
        ],
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    IconData iconData;
    Color iconColor;

    switch (integrationId) {
      case 'health_connect':
        iconData = Icons.health_and_safety;
        iconColor = Colors.green;
        break;
      case 'strava':
        iconData = Icons.directions_run;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.integration_instructions;
        iconColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 48,
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme, ColorScheme colorScheme, Integration integration) {
    String statusText;
    Color statusColor;

    switch (integration.status) {
      case IntegrationStatus.connected:
        statusText = 'Connected';
        statusColor = Colors.green;
        break;
      case IntegrationStatus.syncing:
        statusText = 'Syncing';
        statusColor = Colors.amber;
        break;
      case IntegrationStatus.error:
        statusText = 'Error';
        statusColor = Colors.red;
        break;
      case IntegrationStatus.notConnected:
        statusText = 'Not Connected';
        statusColor = colorScheme.onSurface.withOpacity(0.4);
        break;
    }

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Connection Status', style: theme.textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: OrbitRadius.brCircular,
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthConnectDetails(ThemeData theme, ColorScheme colorScheme, Integration integration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Permissions Granted', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        OrbitSpacing.gapSm,
        OrbitGroupCard(
          children: const [
            OrbitInfoTile(title: 'Steps', leading: Icon(Icons.directions_walk, size: 20)),
            Divider(height: 1, indent: 48),
            OrbitInfoTile(title: 'Sleep', leading: Icon(Icons.nightlight_round, size: 20)),
            Divider(height: 1, indent: 48),
            OrbitInfoTile(title: 'Workouts', leading: Icon(Icons.fitness_center, size: 20)),
          ],
        ),
      ],
    );
  }

  Widget _buildStravaDetails(ThemeData theme, ColorScheme colorScheme, Integration integration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Info', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        OrbitSpacing.gapSm,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: 'Athlete', 
              trailing: Text(integration.metadata['athleteName'] ?? 'Bhavik', style: const TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.person_outline, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, ThemeData theme, ColorScheme colorScheme, Integration integration) {
    final isConnected = integration.status == IntegrationStatus.connected;

    return Column(
      children: [
        if (isConnected) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _sync(context, ref, integration),
              icon: const Icon(Icons.sync),
              label: const Text('Sync Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ),
          OrbitSpacing.gapMd,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showDisconnectDialog(context, ref, integration);
              },
              icon: const Icon(Icons.link_off),
              label: const Text('Disconnect'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                 _connect(context, ref, integration);
              },
              icon: const Icon(Icons.link),
              label: const Text('Connect Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _sync(BuildContext context, WidgetRef ref, Integration integration) async {
    debugPrint('IntegrationDetail: Manual sync started for ${integration.id}');
    if (integration.id == 'health_connect') {
      ref.invalidate(healthSyncProvider);
      ref.invalidate(todayHealthSnapshotProvider);
      await ref.read(healthSyncProvider.future);
      debugPrint('IntegrationDetail: Health Connect sync completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync completed!')),
      );
    }
  }

  void _connect(BuildContext context, WidgetRef ref, Integration integration) async {
    debugPrint('IntegrationDetail: Connect started for ${integration.id}');
    
    if (integration.id == 'health_connect') {
      try {
        final healthService = ref.read(healthServiceProvider);
        
        // 1. Check if already authorized
        bool authorized = await healthService.isAuthorized();
        debugPrint('IntegrationDetail: initial isAuthorized result: $authorized');
        
        if (!authorized) {
          debugPrint('IntegrationDetail: Requesting authorization...');
          authorized = await healthService.requestAuthorization();
          debugPrint('IntegrationDetail: requestAuthorization result: $authorized');
        }
        
        if (authorized) {
          debugPrint('IntegrationDetail: Authorization successful, updating repository...');
          final updated = integration.copyWith(
            status: IntegrationStatus.connected,
            lastSync: DateTime.now(),
          );
          await ref.read(integrationRepositoryProvider).updateIntegration(updated);
          debugPrint('IntegrationDetail: Integration status updated to Connected');
          
          // Force refresh health data and connection status
          ref.invalidate(healthAuthorizationProvider);
          ref.invalidate(todayHealthSnapshotProvider);
          ref.invalidate(currentDailyScoreProvider);
          ref.invalidate(integrationsStreamProvider);
          ref.invalidate(integrationByIdProvider(integration.id));
          
          debugPrint('IntegrationDetail: Starting initial sync...');
          ref.invalidate(healthSyncProvider);
          await ref.read(healthSyncProvider.future);
          debugPrint('IntegrationDetail: Initial sync completed');
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Health Connect connected and synced!')),
            );
          }
        } else {
          debugPrint('IntegrationDetail: Authorization failed or denied');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Authorization failed or denied.')),
            );
          }
        }
      } catch (e) {
        debugPrint('IntegrationDetail: Error during connection: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      // Logic for other integrations
      final updated = integration.copyWith(
        status: IntegrationStatus.connected,
        lastSync: DateTime.now(),
      );
      await ref.read(integrationRepositoryProvider).updateIntegration(updated);
    }
  }

  void _showDisconnectDialog(BuildContext context, WidgetRef ref, Integration integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Integration?'),
        content: Text('Are you sure you want to disconnect ${integration.name}? Orbit will stop receiving new data from this source.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final updated = integration.copyWith(status: IntegrationStatus.notConnected);
              await ref.read(integrationRepositoryProvider).updateIntegration(updated);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Disconnect', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
