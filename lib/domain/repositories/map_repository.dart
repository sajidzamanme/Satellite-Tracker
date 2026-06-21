import 'package:satelite_tracker/domain/entities/iss_position.dart';

abstract class MapRepository {
  Future<IssPosition> getIssPosition();
  Future<String> getCountryOrRegion({required double latitude, required double longitude});
}
