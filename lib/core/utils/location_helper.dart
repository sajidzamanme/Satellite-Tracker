import 'dart:math' as math;

class LocationHelper {
  LocationHelper._();

  static const double proximityRadiusKm = 1000.0;

  /// Calculates the distance in kilometers between two GPS coordinates using the Haversine formula.
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    const double earthRadiusKm = 6371.0;
    
    final dLat = (endLatitude - startLatitude) * math.pi / 180.0;
    final dLon = (endLongitude - startLongitude) * math.pi / 180.0;
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(startLatitude * math.pi / 180.0) * math.cos(endLatitude * math.pi / 180.0) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
        
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Checks if the distance between two coordinates is within the proximity radius.
  static bool isWithinProximity({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final distance = calculateDistance(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );
    return distance <= proximityRadiusKm;
  }
}
