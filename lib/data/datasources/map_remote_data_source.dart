import 'package:dio/dio.dart';
import 'package:satelite_tracker/data/models/iss_position_model.dart';

abstract class MapRemoteDataSource {
  Future<IssPositionModel> getIssPosition();
  Future<String> getCountryOrRegion({required double latitude, required double longitude});
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

  @override
  Future<String> getCountryOrRegion({required double latitude, required double longitude}) async {
    const apiKey = String.fromEnvironment('MAPTILER_API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('MapTiler API Key is missing');
    }

    final response = await dio.get(
      'https://api.maptiler.com/geocoding/$longitude,$latitude.json?key=$apiKey',
    );
    if (response.statusCode == 200) {
      final geocodeData = response.data;
      if (geocodeData is Map<String, dynamic> && geocodeData['features'] is List) {
        final features = geocodeData['features'] as List;
        if (features.isNotEmpty) {
          final countryFeature = features.firstWhere(
            (f) => f is Map<String, dynamic> &&
                   f['place_type'] is List &&
                   (f['place_type'] as List).contains('country'),
            orElse: () => null,
          );
          if (countryFeature != null) {
            return (countryFeature['place_name'] ?? countryFeature['text']) as String;
          } else {
            final firstFeature = features.first as Map<String, dynamic>;
            return (firstFeature['place_name'] ?? firstFeature['text']) as String;
          }
        }
      }
      return 'International Waters';
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
