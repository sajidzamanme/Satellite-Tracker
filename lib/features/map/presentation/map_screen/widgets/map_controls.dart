import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapControls extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
  }) {
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
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
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
                  : Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
