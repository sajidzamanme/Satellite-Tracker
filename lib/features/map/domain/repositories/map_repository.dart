import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';

abstract class MapRepository {
  Future<IssPosition> getIssPosition();
}
