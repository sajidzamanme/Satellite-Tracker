import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satelite_tracker/core/network/dio_provider.dart';
import 'package:satelite_tracker/features/map/data/datasources/map_remote_data_source.dart';
import 'package:satelite_tracker/features/map/data/repositories/map_repository_impl.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';
import 'package:satelite_tracker/features/map/domain/usecases/get_iss_position.dart';
import 'package:satelite_tracker/features/map/domain/usecases/get_country_or_region.dart';

part 'iss_provider.g.dart';

@Riverpod(keepAlive: true)
MapRemoteDataSource mapRemoteDataSource(MapRemoteDataSourceRef ref) {
  return MapRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
MapRepository mapRepository(MapRepositoryRef ref) {
  return MapRepositoryImpl(ref.watch(mapRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetIssPosition getIssPositionUseCase(GetIssPositionUseCaseRef ref) {
  return GetIssPosition(ref.watch(mapRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetCountryOrRegion getCountryOrRegionUseCase(GetCountryOrRegionUseCaseRef ref) {
  return GetCountryOrRegion(ref.watch(mapRepositoryProvider));
}

@Riverpod(keepAlive: true)
class IssPositionNotifier extends _$IssPositionNotifier {
  Timer? _timer;

  @override
  FutureOr<IssPosition> build() async {
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    _startTimer();
    return _fetch();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      refreshPosition();
    });
  }

  Future<IssPosition> _fetch() async {
    final usecase = ref.read(getIssPositionUseCaseProvider);
    return usecase();
  }

  Future<void> refreshPosition() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final data = await _fetch();
      _startTimer();
      return data;
    });
  }
}

@riverpod
class TrackIss extends _$TrackIss {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setTracking(bool value) {
    state = value;
  }
}

@riverpod
Stream<int> issCountdown(IssCountdownRef ref) async* {
  ref.watch(issPositionNotifierProvider);
  yield 60;
  yield* Stream.periodic(
    const Duration(seconds: 1),
    (i) => 59 - i,
  ).take(60);
}

@riverpod
Future<String> issCountry(IssCountryRef ref) async {
  final issState = ref.watch(issPositionNotifierProvider);
  return issState.when(
    data: (position) async {
      final usecase = ref.read(getCountryOrRegionUseCaseProvider);
      return usecase(latitude: position.latitude, longitude: position.longitude);
    },
    error: (err, stack) => 'Error loading location',
    loading: () => Completer<String>().future,
  );
}
