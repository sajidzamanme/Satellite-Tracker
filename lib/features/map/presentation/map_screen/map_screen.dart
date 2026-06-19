import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:satelite_tracker/utils/permission_helper.dart';
import 'map_providers.dart';
import 'widgets/map_header.dart';
import 'widgets/map_controls.dart';
import 'widgets/location_permission_banner.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _isPermissionRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationPermission();
    });
  }

  @override
  void dispose() {
    ref.read(mapControllerProvider.notifier).state = null;
    super.dispose();
  }

  Future<void> _initLocationPermission() async {
    await ref.read(locationPermissionProvider.notifier).checkPermission();
    final permission = ref.read(locationPermissionProvider);
    if (!permission.isGranted) {
      await _requestLocation();
    }
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isPermissionRequested = true;
    });
    await ref.read(locationPermissionProvider.notifier).requestPermission();
    setState(() {
      _isPermissionRequested = false;
    });
  }

  Future<void> _zoomToUser() async {
    final permission = ref.read(locationPermissionProvider);

    if (permission.isGranted) {
      final controller = ref.read(mapControllerProvider);
      if (controller != null) {
        controller.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
      }
    } else {
      await _requestLocation();
      final newPermission = ref.read(locationPermissionProvider);
      if (newPermission.isPermanentlyDenied) {
        _showSettingsSnackBar();
      }
    }
  }

  void _showSettingsSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Location permission permanently denied. Enable in Settings.',
        ),
        action: SnackBarAction(
          label: 'SETTINGS',
          onPressed: () {
            PermissionHelper.openSettings();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permission = ref.watch(locationPermissionProvider);
    final controller = ref.watch(mapControllerProvider);

    ref.listen<PermissionStatus>(locationPermissionProvider, (previous, next) {
      if (next.isGranted) {
        final currentController = ref.read(mapControllerProvider);
        if (currentController != null) {
          currentController.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
        }
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          MapLibreMap(
            styleString: MapStyles.sateliteMap,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0),
              zoom: 0.0,
            ),
            myLocationEnabled: permission.isGranted,
            myLocationTrackingMode: permission.isGranted
                ? MyLocationTrackingMode.tracking
                : MyLocationTrackingMode.none,
            onMapCreated: (MapLibreMapController mapController) {
              ref.read(mapControllerProvider.notifier).state = mapController;
              if (permission.isGranted) {
                mapController.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
              }
            },
          ),

          MapHeader(permissionStatus: permission),

          MapControls(
            controller: controller,
            onZoomToUser: _zoomToUser,
            isLoading: _isPermissionRequested,
          ),

          if (!permission.isGranted)
            LocationPermissionBanner(
              onEnablePressed: () async {
                await _requestLocation();
                final newPermission = ref.read(locationPermissionProvider);
                if (newPermission.isPermanentlyDenied) {
                  _showSettingsSnackBar();
                }
              },
            ),
        ],
      ),
    );
  }
}
