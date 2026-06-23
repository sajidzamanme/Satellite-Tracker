import 'package:fpdart/fpdart.dart';
import 'package:satelite_tracker/core/network/failure.dart';
import 'package:satelite_tracker/features/map/data/datasources/map_remote_data_source.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  const MapRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, IssPosition>> getIssPosition() {
    return TaskEither<Failure, IssPosition>.tryCatch(
      () => remoteDataSource.getIssPosition(),
      (error, stackTrace) => Failure(error.toString()),
    ).run();
  }

  @override
  Future<Either<Failure, String>> getCountryOrRegion({
    required double latitude,
    required double longitude,
  }) {
    return TaskEither<Failure, String>.tryCatch(
      () => remoteDataSource.getCountryOrRegion(latitude: latitude, longitude: longitude),
      (error, stackTrace) => Failure(error.toString()),
    ).run();
  }
}
