import 'package:satelite_tracker/domain/entities/iss_position.dart';
import 'package:satelite_tracker/domain/repositories/map_repository.dart';

class GetIssPosition {
  final MapRepository repository;

  const GetIssPosition(this.repository);

  Future<IssPosition> call() {
    return repository.getIssPosition();
  }
}
