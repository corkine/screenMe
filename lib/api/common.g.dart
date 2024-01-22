// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      user: json['user'] as String? ?? "",
      password: json['password'] as String? ?? "",
      fetchSeconds: json['fetchSeconds'] as int? ?? 60,
      cyberPass: json['cyberPass'] as String? ?? "",
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'fetchSeconds': instance.fetchSeconds,
      'cyberPass': instance.cyberPass,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configsHash() => r'3c5da312ea0b294afdc1733089cf356d485ee75b';

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
