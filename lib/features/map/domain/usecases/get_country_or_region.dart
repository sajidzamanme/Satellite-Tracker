import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';

class GetCountryOrRegion {
  final MapRepository repository;

  const GetCountryOrRegion(this.repository);

  Future<Either<Failure, String>> call({required double latitude, required double longitude}) {
    return repository.getCountryOrRegion(latitude: latitude, longitude: longitude);
  }
}
