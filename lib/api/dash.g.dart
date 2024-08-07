// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashFitImpl _$$DashFitImplFromJson(Map<String, dynamic> json) =>
    _$DashFitImpl(
      stand: (json['stand'] as num?)?.toDouble() ?? 0.0,
      mindful: (json['mindful'] as num?)?.toDouble() ?? 0.0,
      bodyMassMonth: (json['body-mass-month'] as num?)?.toDouble(),
      bodyMassOrigin: (json['body-mass-origin'] as num?)?.toDouble(),
      bodyMassDay30: (json['body-mass-day-30'] as num?)?.toDouble(),
      globalCut: (json['global-cut'] as num?)?.toDouble(),
      globalActive: (json['global-active'] as num?)?.toDouble(),
      accActive: (json['acc-active'] as num?)?.toDouble(),
      accMindful: (json['acc-mindful'] as num?)?.toDouble(),
      marvelMindful: (json['marvel-mindful'] as num?)?.toDouble(),
      marvelActive: (json['marvel-active'] as num?)?.toDouble(),
      exercise: (json['exercise'] as num?)?.toDouble() ?? 0.0,
      active: (json['active'] as num?)?.toDouble() ?? 0.0,
      rest: (json['rest'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$DashFitImplToJson(_$DashFitImpl instance) =>
    <String, dynamic>{
      'stand': instance.stand,
      'mindful': instance.mindful,
      'body-mass-month': instance.bodyMassMonth,
      'body-mass-origin': instance.bodyMassOrigin,
      'body-mass-day-30': instance.bodyMassDay30,
      'global-cut': instance.globalCut,
      'global-active': instance.globalActive,
      'acc-active': instance.accActive,
      'acc-mindful': instance.accMindful,
      'marvel-mindful': instance.marvelMindful,
      'marvel-active': instance.marvelActive,
      'exercise': instance.exercise,
      'active': instance.active,
      'rest': instance.rest,
    };

_$DashTempImpl _$$DashTempImplFromJson(Map<String, dynamic> json) =>
    _$DashTempImpl(
      high: (json['high'] as num?)?.toDouble() ?? 0.0,
      low: (json['low'] as num?)?.toDouble() ?? 0.0,
      diffHigh: (json['diffHigh'] as num?)?.toDouble() ?? 0.0,
      diffLow: (json['diffLow'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$DashTempImplToJson(_$DashTempImpl instance) =>
    <String, dynamic>{
      'high': instance.high,
      'low': instance.low,
      'diffHigh': instance.diffHigh,
      'diffLow': instance.diffLow,
    };

_$DashTodoImpl _$$DashTodoImplFromJson(Map<String, dynamic> json) =>
    _$DashTodoImpl(
      title: json['title'] as String? ?? "",
      createAt: json['create_at'] as String? ?? "",
      isFinished: json['isFinished'] as bool? ?? false,
    );

Map<String, dynamic> _$$DashTodoImplToJson(_$DashTodoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'create_at': instance.createAt,
      'isFinished': instance.isFinished,
    };

_$DashWeatherIconImpl _$$DashWeatherIconImplFromJson(
        Map<String, dynamic> json) =>
    _$DashWeatherIconImpl(
      date: json['date'] as String? ?? "",
      value: $enumDecodeNullable(_$WeatherIconTypeEnumMap, json['value']) ??
          WeatherIconType.UNKNOWN,
    );

Map<String, dynamic> _$$DashWeatherIconImplToJson(
        _$DashWeatherIconImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': _$WeatherIconTypeEnumMap[instance.value]!,
    };

const _$WeatherIconTypeEnumMap = {
  WeatherIconType.CLEAR_DAY: 'CLEAR_DAY',
  WeatherIconType.CLEAR_NIGHT: 'CLEAR_NIGHT',
  WeatherIconType.PARTLY_CLOUDY_DAY: 'PARTLY_CLOUDY_DAY',
  WeatherIconType.PARTLY_CLOUDY_NIGHT: 'PARTLY_CLOUDY_NIGHT',
  WeatherIconType.CLOUDY: 'CLOUDY',
  WeatherIconType.LIGHT_HAZE: 'LIGHT_HAZE',
  WeatherIconType.MODERATE_HAZE: 'MODERATE_HAZE',
  WeatherIconType.HEAVY_HAZE: 'HEAVY_HAZE',
  WeatherIconType.LIGHT_RAIN: 'LIGHT_RAIN',
  WeatherIconType.MODERATE_RAIN: 'MODERATE_RAIN',
  WeatherIconType.HEAVY_RAIN: 'HEAVY_RAIN',
  WeatherIconType.STORM_RAIN: 'STORM_RAIN',
  WeatherIconType.FOG: 'FOG',
  WeatherIconType.LIGHT_SNOW: 'LIGHT_SNOW',
  WeatherIconType.MODERATE_SNOW: 'MODERATE_SNOW',
  WeatherIconType.HEAVY_SNOW: 'HEAVY_SNOW',
  WeatherIconType.STORM_SNOW: 'STORM_SNOW',
  WeatherIconType.DUST: 'DUST',
  WeatherIconType.SAND: 'SAND',
  WeatherIconType.WIND: 'WIND',
  WeatherIconType.UNKNOWN: 'UNKNOWN',
};

_$DashInfoImpl _$$DashInfoImplFromJson(Map<String, dynamic> json) =>
    _$DashInfoImpl(
      updateAt: (json['updateAt'] as num?)?.toInt() ?? 0,
      needDiaryReport: json['needDiaryReport'] as bool? ?? false,
      weatherInfo: json['weatherInfo'] as String? ?? "",
      weatherIcon: json['weatherIcon'] == null
          ? const DashWeatherIcon(date: "", value: WeatherIconType.UNKNOWN)
          : DashWeatherIcon.fromJson(
              json['weatherIcon'] as Map<String, dynamic>),
      needPlantWater: json['needPlantWater'] as bool? ?? false,
      cardCheck: (json['cardCheck'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      todo: (json['todo'] as List<dynamic>?)
              ?.map((e) => DashTodo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      offWork: json['offWork'] as bool? ?? false,
      workStatus: json['workStatus'] as String? ?? "",
      tempInfo: json['tempInfo'] == null
          ? const DashTemp()
          : DashTemp.fromJson(json['tempInfo'] as Map<String, dynamic>),
      tempFutureInfo: json['tempFutureInfo'] == null
          ? const DashTemp()
          : DashTemp.fromJson(json['tempFutureInfo'] as Map<String, dynamic>),
      fitnessInfo: json['fitnessInfo'] == null
          ? const DashFit()
          : DashFit.fromJson(json['fitnessInfo'] as Map<String, dynamic>),
      debugInfo: json['debugInfo'] as String? ?? "",
      lastError: json['lastError'] as String? ?? "",
      express: (json['express'] as List<dynamic>?)
              ?.map((e) => DashExpress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashInfoImplToJson(_$DashInfoImpl instance) =>
    <String, dynamic>{
      'updateAt': instance.updateAt,
      'needDiaryReport': instance.needDiaryReport,
      'weatherInfo': instance.weatherInfo,
      'weatherIcon': instance.weatherIcon,
      'needPlantWater': instance.needPlantWater,
      'cardCheck': instance.cardCheck,
      'todo': instance.todo,
      'offWork': instance.offWork,
      'workStatus': instance.workStatus,
      'tempInfo': instance.tempInfo,
      'tempFutureInfo': instance.tempFutureInfo,
      'fitnessInfo': instance.fitnessInfo,
      'debugInfo': instance.debugInfo,
      'lastError': instance.lastError,
      'express': instance.express,
    };

_$DashExpressImpl _$$DashExpressImplFromJson(Map<String, dynamic> json) =>
    _$DashExpressImpl(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      status: (json['status'] as num?)?.toInt() ?? 0,
      lastUpdate: json['last_update'] as String? ?? "",
      info: json['info'] as String? ?? "",
      extra: (json['extra'] as List<dynamic>?)
              ?.map((e) => DashExpressExtra.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashExpressImplToJson(_$DashExpressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'last_update': instance.lastUpdate,
      'info': instance.info,
      'extra': instance.extra,
    };

_$DashExpressExtraImpl _$$DashExpressExtraImplFromJson(
        Map<String, dynamic> json) =>
    _$DashExpressExtraImpl(
      time: json['time'] as String? ?? "",
      status: json['status'] ?? "",
    );

Map<String, dynamic> _$$DashExpressExtraImplToJson(
        _$DashExpressExtraImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'status': instance.status,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getExpressHash() => r'f8e3622ece53c26567b72a717395612d8e8c1194';

/// See also [getExpress].
@ProviderFor(getExpress)
final getExpressProvider =
    AutoDisposeFutureProvider<List<DashExpress>>.internal(
  getExpress,
  name: r'getExpressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getExpressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetExpressRef = AutoDisposeFutureProviderRef<List<DashExpress>>;
String _$getDashHash() => r'02a77cb98fdeb960853f36daefdfe93631a899f4';

/// See also [getDash].
@ProviderFor(getDash)
final getDashProvider = AutoDisposeFutureProvider<DashInfo>.internal(
  getDash,
  name: r'getDashProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getDashHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetDashRef = AutoDisposeFutureProviderRef<DashInfo>;
String _$timesHash() => r'9af21052901b2d850f71123e20dd8432c6bab5b7';

/// See also [Times].
@ProviderFor(Times)
final timesProvider = AutoDisposeStreamNotifierProvider<Times, int>.internal(
  Times.new,
  name: r'timesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Times = AutoDisposeStreamNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
