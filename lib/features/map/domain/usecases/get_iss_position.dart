import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';

class GetIssPosition {
  final MapRepository repository;

  const GetIssPosition(this.repository);

  Future<Either<Failure, IssPosition>> call() {
    return repository.getIssPosition();
  }
}
