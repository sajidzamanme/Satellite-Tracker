import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satelite_tracker/core/utils/permission_helper.dart';

part 'map_providers.g.dart';

class MapStyles {
  MapStyles._();

  static const String _apiKey = String.fromEnvironment('MAPTILER_API_KEY');

  static const String sateliteMap = 'https://api.maptiler.com/maps/hybrid-v4/style.json?key=$_apiKey';
}

@Riverpod(keepAlive: true)
class LocationPermission extends _$LocationPermission {
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

@Riverpod(keepAlive: true)
class MapController extends _$MapController {
  @override
  MapLibreMapController? build() => null;

  void setController(MapLibreMapController? controller) {
    state = controller;
  }
}

@Riverpod(keepAlive: true)
class TrackUser extends _$TrackUser {
  @override
  bool build() => false;

  void setTracking(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}
