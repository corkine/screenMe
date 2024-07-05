// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      user: json['user'] as String? ?? "",
      password: json['password'] as String? ?? "",
      fetchSeconds: (json['fetchSeconds'] as num?)?.toInt() ?? 60,
      showBingWallpaper: json['showBingWallpaper'] as bool? ?? false,
      cyberPass: json['cyberPass'] as String? ?? "",
      demoMode: json['demoMode'] as bool? ?? true,
      useAnimationInHealthViewWhenNoTodo:
          json['useAnimationInHealthViewWhenNoTodo'] as bool? ?? true,
      maxVolDelaySeconds:
          (json['maxVolDelaySeconds'] as num?)?.toDouble() ?? 0.0,
      showFatWarningAfter17IfLazy:
          json['showFatWarningAfter17IfLazy'] as bool? ?? false,
      fatWarningOverwriteBingWallpaper:
          json['fatWarningOverwriteBingWallpaper'] as bool? ?? false,
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
      'maxVolDelaySeconds': instance.maxVolDelaySeconds,
      'showFatWarningAfter17IfLazy': instance.showFatWarningAfter17IfLazy,
      'fatWarningOverwriteBingWallpaper':
          instance.fatWarningOverwriteBingWallpaper,
      'volumeNormal': instance.volumeNormal,
      'volumeOpenBluetooth': instance.volumeOpenBluetooth,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configsHash() => r'a32c699ce80e100193eae0a38312d5ebd6ab034f';

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
