import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';

abstract class MapRepository {
  Future<Either<Failure, IssPosition>> getIssPosition();
  Future<Either<Failure, String>> getCountryOrRegion({required double latitude, required double longitude});
}
