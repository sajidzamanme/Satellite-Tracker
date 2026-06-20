import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';

class IssPositionModel extends IssPosition {
  const IssPositionModel({
    required super.latitude,
    required super.longitude,
    required super.timestamp,
    required super.message,
  });

  factory IssPositionModel.fromJson(Map<String, dynamic> json) {
    final positionJson = json['iss_position'] as Map<String, dynamic>;
    return IssPositionModel(
      latitude: double.parse(positionJson['latitude']),
      longitude: double.parse(positionJson['longitude']),
      timestamp: json['timestamp'] as int,
      message: json['message'] as String,
    );
  }
}
