import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/utils/permission_helper.dart';
import 'map_providers.dart';
import 'iss_provider.dart';
import 'widgets/map_header.dart';
import 'widgets/map_controls.dart';
import 'widgets/location_permission_banner.dart';
import 'widgets/iss_status_card.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _isPermissionRequested = false;
  Symbol? _issSymbol;
  bool _hasStyleLoaded = false;

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
        ref.read(trackIssProvider.notifier).state = false;
        ref.read(trackUserProvider.notifier).state = true;
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

  Future<void> _onStyleLoaded() async {
    final controller = ref.read(mapControllerProvider);
    if (controller != null) {
      final ByteData data = await rootBundle.load('assets/images/satellite.png');
      final Uint8List markerBytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await controller.addImage('iss_marker_icon', markerBytes);
      _hasStyleLoaded = true;
      _updateIssMarkerPosition();
    }
  }

  Future<void> _updateIssMarkerPosition() async {
    if (!_hasStyleLoaded) return;
    
    final controller = ref.read(mapControllerProvider);
    if (controller == null) return;

    final issState = ref.read(issPositionNotifierProvider);
    issState.whenData((position) async {
      final targetLatLng = LatLng(position.latitude, position.longitude);

      if (_issSymbol == null) {
        _issSymbol = await controller.addSymbol(
          SymbolOptions(
            geometry: targetLatLng,
            iconImage: 'iss_marker_icon',
            iconSize: 0.25,
            iconAnchor: 'center',
          ),
        );
      } else {
        await controller.updateSymbol(
          _issSymbol!,
          SymbolOptions(
            geometry: targetLatLng,
          ),
        );
      }

      final trackIss = ref.read(trackIssProvider);
      if (trackIss) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(targetLatLng, 3.5),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final permission = ref.watch(locationPermissionProvider);
    final controller = ref.watch(mapControllerProvider);

    ref.listen<PermissionStatus>(locationPermissionProvider, (previous, next) {
      if (next.isGranted) {
        ref.read(trackUserProvider.notifier).state = true;
        ref.read(trackIssProvider.notifier).state = false;
        final currentController = ref.read(mapControllerProvider);
        if (currentController != null) {
          currentController.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
        }
      }
    });

    ref.listen<AsyncValue<IssPosition>>(issPositionNotifierProvider, (previous, next) {
      if (next is AsyncData<IssPosition>) {
        _updateIssMarkerPosition();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating ISS position: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    ref.listen<bool>(trackUserProvider, (previous, next) {
      final currentController = ref.read(mapControllerProvider);
      if (currentController != null) {
        if (next) {
          ref.read(trackIssProvider.notifier).state = false;
          currentController.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
        } else {
          currentController.updateMyLocationTrackingMode(MyLocationTrackingMode.none);
        }
      }
    });

    ref.listen<bool>(trackIssProvider, (previous, next) {
      if (next) {
        ref.read(trackUserProvider.notifier).state = false;
        _updateIssMarkerPosition();
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
                ref.read(trackUserProvider.notifier).state = true;
                mapController.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
              }
            },
            onStyleLoadedCallback: _onStyleLoaded,
            onCameraTrackingDismissed: () {
              ref.read(trackUserProvider.notifier).state = false;
            },
          ),

          MapHeader(permissionStatus: permission),

          MapControls(
            controller: controller,
            onZoomToUser: _zoomToUser,
            isLoading: _isPermissionRequested,
          ),

          const IssStatusCard(),

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
