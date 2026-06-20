import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<PermissionStatus> checkLocationPermissionStatus() {
    return Permission.locationWhenInUse.status;
  }

  static Future<PermissionStatus> requestLocationPermission() {
    return Permission.locationWhenInUse.request();
  }

  static Future<bool> openSettings() {
    return openAppSettings();
  }
}
