// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationPermissionHash() =>
    r'774cbecd3c34b9615106981cd40325c7c62f2800';

/// See also [LocationPermission].
@ProviderFor(LocationPermission)
final locationPermissionProvider =
    NotifierProvider<LocationPermission, PermissionStatus>.internal(
      LocationPermission.new,
      name: r'locationPermissionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationPermissionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocationPermission = Notifier<PermissionStatus>;
String _$mapControllerHash() => r'9bacbc8a33789b4f1fd0f0ece6573044dabf05aa';

/// See also [MapController].
@ProviderFor(MapController)
final mapControllerProvider =
    NotifierProvider<MapController, MapLibreMapController?>.internal(
      MapController.new,
      name: r'mapControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapController = Notifier<MapLibreMapController?>;
String _$trackUserHash() => r'4cccc433574624345731915118c3224c9f34b2e9';

/// See also [TrackUser].
@ProviderFor(TrackUser)
final trackUserProvider = NotifierProvider<TrackUser, bool>.internal(
  TrackUser.new,
  name: r'trackUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trackUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TrackUser = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
