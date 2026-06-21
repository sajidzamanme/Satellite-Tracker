import 'package:satelite_tracker/domain/repositories/map_repository.dart';

class GetCountryOrRegion {
  final MapRepository repository;

  const GetCountryOrRegion(this.repository);

  Future<String> call({required double latitude, required double longitude}) {
    return repository.getCountryOrRegion(latitude: latitude, longitude: longitude);
  }
}
