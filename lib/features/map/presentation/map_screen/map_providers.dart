import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:satelite_tracker/utils/permission_helper.dart';

class MapStyles {
  MapStyles._();

  static const String _apiKey = String.fromEnvironment('MAPTILER_API_KEY');

  static const String sateliteMap = 'https://api.maptiler.com/maps/hybrid-v4/style.json?key=$_apiKey';
}

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, PermissionStatus>((ref) {
  return LocationPermissionNotifier();
});

final mapControllerProvider = StateProvider<MapLibreMapController?>((ref) {
  return null;
});

class LocationPermissionNotifier extends StateNotifier<PermissionStatus> {
  LocationPermissionNotifier() : super(PermissionStatus.denied) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    state = await PermissionHelper.checkLocationPermissionStatus();
  }

  Future<void> requestPermission() async {
    state = await PermissionHelper.requestLocationPermission();
  }
}
