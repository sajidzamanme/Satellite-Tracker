import 'package:dio/dio.dart';
import 'package:satelite_tracker/features/map/data/models/iss_position_model.dart';

abstract class MapRemoteDataSource {
  Future<IssPositionModel> getIssPosition();
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final Dio dio;

  const MapRemoteDataSourceImpl(this.dio);

  @override
  Future<IssPositionModel> getIssPosition() async {
    final response = await dio.get('http://api.open-notify.org/iss-now.json');
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return IssPositionModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Invalid JSON structure from ISS API',
        );
      }
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
