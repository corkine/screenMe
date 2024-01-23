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
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'fetchSeconds': instance.fetchSeconds,
      'showBingWallpaper': instance.showBingWallpaper,
      'cyberPass': instance.cyberPass,
      'demoMode': instance.demoMode,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configsHash() => r'0db4b59733e0f3847169eb76e2130fc1b1233f1c';

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
