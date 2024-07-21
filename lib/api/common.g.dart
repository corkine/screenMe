// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      user: json['user'] as String? ?? "",
      password: json['password'] as String? ?? "",
      fetchSeconds: (json['fetchSeconds'] as num?)?.toInt() ?? 60,
      face:
          $enumDecodeNullable(_$FaceTypeEnumMap, json['face']) ?? FaceType.bing,
      cyberPass: json['cyberPass'] as String? ?? "",
      demoMode: json['demoMode'] as bool? ?? true,
      useAnimationWhenNoTodo: json['useAnimationWhenNoTodo'] as bool? ?? true,
      maxVolDelaySeconds:
          (json['maxVolDelaySeconds'] as num?)?.toDouble() ?? 20.0,
      showFatWarningAfter17IfLazy:
          json['showFatWarningAfter17IfLazy'] as bool? ?? false,
      warningType:
          $enumDecodeNullable(_$WarnTypeEnumMap, json['warningType']) ??
              WarnType.eye,
      fatWarningOverwriteBingWallpaper:
          json['fatWarningOverwriteBingWallpaper'] as bool? ?? false,
      volumeNormal: (json['volumeNormal'] as num?)?.toDouble() ?? 0.1,
      volumeOpenBluetooth:
          (json['volumeOpenBluetooth'] as num?)?.toDouble() ?? 0.7,
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'fetchSeconds': instance.fetchSeconds,
      'face': _$FaceTypeEnumMap[instance.face]!,
      'cyberPass': instance.cyberPass,
      'demoMode': instance.demoMode,
      'useAnimationWhenNoTodo': instance.useAnimationWhenNoTodo,
      'maxVolDelaySeconds': instance.maxVolDelaySeconds,
      'showFatWarningAfter17IfLazy': instance.showFatWarningAfter17IfLazy,
      'warningType': _$WarnTypeEnumMap[instance.warningType]!,
      'fatWarningOverwriteBingWallpaper':
          instance.fatWarningOverwriteBingWallpaper,
      'volumeNormal': instance.volumeNormal,
      'volumeOpenBluetooth': instance.volumeOpenBluetooth,
    };

const _$FaceTypeEnumMap = {
  FaceType.bing: 'bing',
  FaceType.gallery: 'gallery',
  FaceType.fit: 'fit',
  FaceType.warning: 'warning',
};

const _$WarnTypeEnumMap = {
  WarnType.eye: 'eye',
  WarnType.yoga: 'yoga',
  WarnType.water: 'water',
  WarnType.random: 'random',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configsHash() => r'80c303945453db6543481768d80df3a8df6fa7bf';

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
