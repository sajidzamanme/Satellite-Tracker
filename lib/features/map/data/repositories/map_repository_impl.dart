import 'package:satelite_tracker/features/map/data/datasources/map_remote_data_source.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  const MapRepositoryImpl(this.remoteDataSource);

  @override
  Future<IssPosition> getIssPosition() {
    return remoteDataSource.getIssPosition();
  }
}
