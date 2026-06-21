import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:satelite_tracker/presentation/state/iss_provider.dart';
import 'package:satelite_tracker/presentation/state/map_providers.dart';

class MapControls extends ConsumerWidget {
  final MapLibreMapController? controller;
  final VoidCallback onZoomToUser;
  final bool isLoading;

  const MapControls({
    super.key,
    required this.controller,
    required this.onZoomToUser,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackIss = ref.watch(trackIssProvider);
    final trackUser = ref.watch(trackUserProvider);

    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatingButton(
            context,
            icon: Icons.add,
            onPressed: () {
              controller?.animateCamera(CameraUpdate.zoomIn());
            },
          ),
          const SizedBox(height: 12),
          _buildFloatingButton(
            context,
            icon: Icons.remove,
            onPressed: () {
              controller?.animateCamera(CameraUpdate.zoomOut());
            },
          ),
          const SizedBox(height: 12),
          _buildFloatingButton(
            context,
            icon: Icons.my_location,
            onPressed: onZoomToUser,
            isLoading: isLoading,
            isActive: trackUser,
            activeColor: Colors.blueAccent,
          ),
          const SizedBox(height: 12),
          _buildFloatingButton(
            context,
            icon: Icons.satellite_alt,
            onPressed: () {
              ref.read(trackIssProvider.notifier).state = !trackIss;
            },
            isActive: trackIss,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isActive = false,
    Color? activeColor,
  }) {
    final buttonColor = isActive && activeColor != null
        ? activeColor.withValues(alpha: 0.6)
        : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6);
    final borderColor = isActive && activeColor != null
        ? activeColor
        : Theme.of(context).colorScheme.outline;
    final iconColor = isActive && activeColor != null
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: buttonColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
