// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iss_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapRemoteDataSourceHash() =>
    r'6c652a3c1ec766e31e8a94ade08d1321cc63ccfb';

/// See also [mapRemoteDataSource].
@ProviderFor(mapRemoteDataSource)
final mapRemoteDataSourceProvider = Provider<MapRemoteDataSource>.internal(
  mapRemoteDataSource,
  name: r'mapRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mapRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MapRemoteDataSourceRef = ProviderRef<MapRemoteDataSource>;
String _$mapRepositoryHash() => r'b4379c3ff12bfc6980ebf9a5235296bc13cf209d';

/// See also [mapRepository].
@ProviderFor(mapRepository)
final mapRepositoryProvider = Provider<MapRepository>.internal(
  mapRepository,
  name: r'mapRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mapRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MapRepositoryRef = ProviderRef<MapRepository>;
String _$getIssPositionUseCaseHash() =>
    r'5fed3420b8328970800a5c5438e7eaf17373dc86';

/// See also [getIssPositionUseCase].
@ProviderFor(getIssPositionUseCase)
final getIssPositionUseCaseProvider = Provider<GetIssPosition>.internal(
  getIssPositionUseCase,
  name: r'getIssPositionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getIssPositionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetIssPositionUseCaseRef = ProviderRef<GetIssPosition>;
String _$getCountryOrRegionUseCaseHash() =>
    r'52ab2616aea6130fcf355b0ba2375bda360b82e8';

/// See also [getCountryOrRegionUseCase].
@ProviderFor(getCountryOrRegionUseCase)
final getCountryOrRegionUseCaseProvider = Provider<GetCountryOrRegion>.internal(
  getCountryOrRegionUseCase,
  name: r'getCountryOrRegionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCountryOrRegionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCountryOrRegionUseCaseRef = ProviderRef<GetCountryOrRegion>;
String _$issCountdownHash() => r'ebc04f822ac55c70e863ae1c22a4f386f12b1a7d';

/// See also [issCountdown].
@ProviderFor(issCountdown)
final issCountdownProvider = AutoDisposeStreamProvider<int>.internal(
  issCountdown,
  name: r'issCountdownProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$issCountdownHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IssCountdownRef = AutoDisposeStreamProviderRef<int>;
String _$issCountryHash() => r'b38f27507a8f4eab506790200aaf401772d7f7ad';

/// See also [issCountry].
@ProviderFor(issCountry)
final issCountryProvider = AutoDisposeFutureProvider<String>.internal(
  issCountry,
  name: r'issCountryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$issCountryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IssCountryRef = AutoDisposeFutureProviderRef<String>;
String _$issPositionNotifierHash() =>
    r'daeb011765ce55b0d1532ec41bc1767e3c88479f';

/// See also [IssPositionNotifier].
@ProviderFor(IssPositionNotifier)
final issPositionNotifierProvider =
    AsyncNotifierProvider<IssPositionNotifier, IssPosition>.internal(
      IssPositionNotifier.new,
      name: r'issPositionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$issPositionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IssPositionNotifier = AsyncNotifier<IssPosition>;
String _$trackIssHash() => r'3cb8ea115750d6c1d5b18538a89fb57ed1488ac9';

/// See also [TrackIss].
@ProviderFor(TrackIss)
final trackIssProvider = AutoDisposeNotifierProvider<TrackIss, bool>.internal(
  TrackIss.new,
  name: r'trackIssProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trackIssHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TrackIss = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
