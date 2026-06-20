import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:satelite_tracker/core/utils/permission_helper.dart';

class MapStyles {
  MapStyles._();

  static const String _apiKey = String.fromEnvironment('MAPTILER_API_KEY');

  static const String sateliteMap = 'https://api.maptiler.com/maps/hybrid-v4/style.json?key=$_apiKey';
}

final locationPermissionProvider =
    NotifierProvider<LocationPermissionNotifier, PermissionStatus>(() {
  return LocationPermissionNotifier();
});

final mapControllerProvider = StateProvider<MapLibreMapController?>((ref) {
  return null;
});

final trackUserProvider = StateProvider<bool>((ref) {
  return false;
});

class LocationPermissionNotifier extends Notifier<PermissionStatus> {
  @override
  PermissionStatus build() {
    return PermissionStatus.denied;
  }

  Future<PermissionStatus> checkPermission() async {
    final status = await PermissionHelper.checkLocationPermissionStatus();
    state = status;
    return status;
  }

  Future<PermissionStatus> requestPermission() async {
    final status = await PermissionHelper.requestLocationPermission();
    state = status;
    return status;
  }
}
