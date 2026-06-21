import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:satelite_tracker/features/map/presentation/providers/iss_provider.dart';
import 'package:satelite_tracker/features/map/presentation/providers/map_providers.dart';

class IssStatusCard extends ConsumerWidget {
  const IssStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issState = ref.watch(issPositionNotifierProvider);
    final permission = ref.watch(locationPermissionProvider);
    final countdownAsync = ref.watch(issCountdownProvider);
    final countdown = countdownAsync.value ?? 00;
    final countryState = ref.watch(issCountryProvider);
    
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final bottomOffset = permission.isGranted ? bottomPadding + 8 : bottomPadding + 94.0;

    return Positioned(
      bottom: bottomOffset,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: issState.when(
                              data: (_) => const Color(0xFF4AF626),
                              error: (_, _) => Theme.of(context).colorScheme.error,
                              loading: () => Colors.amber,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: issState.when(
                                  data: (_) => const Color(0xFF4AF626).withValues(alpha: 0.5),
                                  error: (_, _) => Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                                  loading: () => Colors.amber.withValues(alpha: 0.5),
                                ),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ISS SATELLITE POSITION',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: issState.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blueAccent,
                              ),
                            )
                          : const Icon(Icons.refresh, size: 18),
                      onPressed: issState.isLoading
                          ? null
                          : () {
                              ref.read(issPositionNotifierProvider.notifier).refreshPosition();
                            },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                issState.when(
                  data: (position) {
                    final latStr = position.latitude.toStringAsFixed(4);
                    final lonStr = position.longitude.toStringAsFixed(4);
                    final localTime = DateTime.fromMillisecondsSinceEpoch(position.timestamp * 1000);
                    final utcTime = localTime.toUtc();
                    String formatTime(DateTime dt) =>
                        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
                    final localTimeStr = formatTime(localTime);
                    final utcTimeStr = formatTime(utcTime);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildCoordinateColumn(
                                context,
                                label: 'LATITUDE',
                                value: '$latStr°',
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            Expanded(
                              child: _buildCoordinateColumn(
                                context,
                                label: 'LONGITUDE',
                                value: '$lonStr°',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Country / Region',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(height: 4),
                              countryState.when(
                                data: (country) => Text(
                                  country,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                loading: () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Searching region...',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                                error: (err, _) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Error loading region',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        ref.invalidate(issCountryProvider);
                                      },
                                      borderRadius: BorderRadius.circular(4),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              size: 12,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              'Retry',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'monospace',
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Countdown: ${countdown}s',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              'Fetched: $localTimeStr | $utcTimeStr UTC',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  error: (error, _) => Text(
                    'Failed to track ISS: ${error.toString().split('\n').first}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Updating coordinates...',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinateColumn(BuildContext context, {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 10,
              letterSpacing: 1.0,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
