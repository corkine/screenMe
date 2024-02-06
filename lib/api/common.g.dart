// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      user: json['user'] as String? ?? "",
      password: json['password'] as String? ?? "",
      fetchSeconds: json['fetchSeconds'] as int? ?? 60,
      showBingWallpaper: json['showBingWallpaper'] as bool? ?? false,
      cyberPass: json['cyberPass'] as String? ?? "",
      demoMode: json['demoMode'] as bool? ?? true,
      useAnimationInHealthViewWhenNoTodo:
          json['useAnimationInHealthViewWhenNoTodo'] as bool? ?? true,
      showFatWarningAfter17IfLazy:
          json['showFatWarningAfter17IfLazy'] as bool? ?? false,
      volumeNormal: (json['volumeNormal'] as num?)?.toDouble() ?? 0.1,
      volumeOpenBluetooth:
          (json['volumeOpenBluetooth'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'fetchSeconds': instance.fetchSeconds,
      'showBingWallpaper': instance.showBingWallpaper,
      'cyberPass': instance.cyberPass,
      'demoMode': instance.demoMode,
      'useAnimationInHealthViewWhenNoTodo':
          instance.useAnimationInHealthViewWhenNoTodo,
      'showFatWarningAfter17IfLazy': instance.showFatWarningAfter17IfLazy,
      'volumeNormal': instance.volumeNormal,
      'volumeOpenBluetooth': instance.volumeOpenBluetooth,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configsHash() => r'cff7b61963f71ae9b5eaca5965c9a42d0475d24f';

/// See also [Configs].
@ProviderFor(Configs)
final configsProvider =
    AutoDisposeAsyncNotifierProvider<Configs, Config>.internal(
  Configs.new,
  name: r'configsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$configsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Configs = AutoDisposeAsyncNotifier<Config>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
