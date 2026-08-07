import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/integration.dart';
import '../providers/integration_providers.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../core/theme/orbit_radius.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';
import '../../../health/presentation/providers/health_providers.dart';
import '../../strava/presentation/providers/strava_providers.dart';
import '../../../../features/dashboard/presentation/providers/dashboard_provider.dart';

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
                OrbitSpacing.gapXxl,
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
                 style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
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
        color: iconColor.withValues(alpha: 0.1),
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
        statusColor = colorScheme.onSurface.withValues(alpha: 0.4);
        break;
    }

    final errorMessage = integration.metadata['errorMessage'] as String?;

    return Column(
      children: [
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.lg),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Connection Status', style: theme.textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
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
        ),
        if (errorMessage != null) ...[
          OrbitSpacing.gapMd,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
        ],
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
    final metadata = integration.metadata;
    final athleteName = metadata['athleteName'] as String? ?? 'Not provided';
    final activityCount = (metadata['activityCount'] as num?)?.toInt() ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Strava Account', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        OrbitSpacing.gapSm,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: 'Athlete', 
              trailing: Text(athleteName, style: const TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.person_outline, size: 20),
            ),
            const Divider(height: 1, indent: 56),
            OrbitInfoTile(
              title: 'Activities Synced', 
              trailing: Text('$activityCount', style: const TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.history, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, ThemeData theme, ColorScheme colorScheme, Integration integration) {
    final isConnected = integration.status == IntegrationStatus.connected;
    final isSyncing = integration.status == IntegrationStatus.syncing;

    return Column(
      children: [
        if (isConnected || isSyncing) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSyncing ? null : () => _sync(context, ref, integration),
              icon: isSyncing 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync),
              label: Text(isSyncing ? 'Syncing...' : 'Sync Now'),
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
              onPressed: isSyncing ? null : () {
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
              label: const Text('Connect Strava'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFFFC6100), // Strava Orange
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _sync(BuildContext context, WidgetRef ref, Integration integration) async {
    debugPrint('[INTEGRATION] manual sync started for ${integration.id}');
    if (integration.id == 'health_connect') {
      await ref.read(healthSyncNotifierProvider.notifier).sync();
      ref.invalidate(dashboardProvider);
    } else if (integration.id == 'strava') {
      try {
        final count = await ref.read(stravaSyncNotifierProvider.notifier).sync();
        ref.invalidate(dashboardProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sync complete! Found $count new activities.')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sync failed: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _connect(BuildContext context, WidgetRef ref, Integration integration) async {
    debugPrint('[INTEGRATION] connect started for ${integration.id}');
    
    if (integration.id == 'health_connect') {
      try {
        final healthService = ref.read(healthServiceProvider);
        bool authorized = await healthService.isAuthorized();
        if (!authorized) {
          authorized = await healthService.requestAuthorization();
        }
        
        if (authorized) {
          final updated = integration.copyWith(
            status: IntegrationStatus.connected,
            lastSync: DateTime.now(),
          );
          await ref.read(integrationRepositoryProvider).updateIntegration(updated);
          
          ref.invalidate(healthAuthorizationProvider);
          ref.invalidate(todayHealthSnapshotProvider);
          ref.invalidate(integrationsStreamProvider);
          ref.invalidate(integrationByIdProvider(integration.id));
          
          await ref.read(healthSyncNotifierProvider.notifier).sync();
          ref.invalidate(dashboardProvider);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Health Connect connected and synced!')),
            );
          }
        }
      } catch (e) {
         if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    } else if (integration.id == 'strava') {
      try {
        await ref.read(stravaAuthNotifierProvider.notifier).connect();
      } catch (e) {
        debugPrint('[STRAVA] ERR Exception during connection: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open Strava: $e'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
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
        title: Text('Disconnect ${integration.name}?'),
        content: Text('Are you sure you want to disconnect ${integration.name}? Orbit will stop receiving new data from this source.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (integration.id == 'strava') {
                await ref.read(stravaSyncNotifierProvider.notifier).disconnect();
              } else {
                final updated = integration.copyWith(status: IntegrationStatus.notConnected);
                await ref.read(integrationRepositoryProvider).updateIntegration(updated);
              }
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
