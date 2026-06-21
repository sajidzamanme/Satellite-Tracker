import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHeader extends StatelessWidget {
  final PermissionStatus permissionStatus;
  final bool isIssClose;
  final double? currentDistanceKm;
  final VoidCallback? onLongPress;

  const MapHeader({
    super.key,
    required this.permissionStatus,
    this.isIssClose = false,
    this.currentDistanceKm,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'SATELLITE TRACKER',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                            child: Text(
                              permissionStatus.isGranted
                                  ? 'GPS Active'
                                  : permissionStatus.isDenied
                                  ? 'Location Disabled'
                                  : 'Permission Restricted',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: permissionStatus.isGranted
                                    ? const Color(0xFF4AF626)
                                    : Colors.orangeAccent,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isIssClose
                        ? Column(
                            children: [
                              const SizedBox(height: 12),
                              Divider(
                                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'The Space Station is above you!!${currentDistanceKm != null ? " (~${currentDistanceKm!.toStringAsFixed(0)} km)" : ""}',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
