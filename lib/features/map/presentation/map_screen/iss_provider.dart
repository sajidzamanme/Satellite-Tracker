import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satelite_tracker/features/map/data/datasources/map_remote_data_source.dart';
import 'package:satelite_tracker/features/map/data/repositories/map_repository_impl.dart';
import 'package:satelite_tracker/features/map/domain/entities/iss_position.dart';
import 'package:satelite_tracker/features/map/domain/repositories/map_repository.dart';
import 'package:satelite_tracker/features/map/domain/usecases/get_iss_position.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final mapRemoteDataSourceProvider = Provider<MapRemoteDataSource>((ref) {
  return MapRemoteDataSourceImpl(ref.watch(dioProvider));
});

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(ref.watch(mapRemoteDataSourceProvider));
});

final getIssPositionUseCaseProvider = Provider<GetIssPosition>((ref) {
  return GetIssPosition(ref.watch(mapRepositoryProvider));
});

class IssPositionNotifier extends AsyncNotifier<IssPosition> {
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

final issPositionNotifierProvider =
    AsyncNotifierProvider<IssPositionNotifier, IssPosition>(() {
  return IssPositionNotifier();
});

final trackIssProvider = StateProvider<bool>((ref) {
  return false; // Automatically follow ISS by default
});

final issCountdownProvider = StreamProvider<int>((ref) async* {
  ref.watch(issPositionNotifierProvider);
  yield 60;
  yield* Stream.periodic(
    const Duration(seconds: 1),
    (i) => 59 - i,
  ).take(60);
});
