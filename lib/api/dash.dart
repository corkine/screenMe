// ignore_for_file: invalid_annotation_target, constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_me/api/core.dart';
import 'package:screen_me/version.dart';

part 'dash.freezed.dart';
part 'dash.g.dart';

@freezed
class DashFit with _$DashFit {
  const factory DashFit({
    @Default(0.0) double stand,
    @Default(0.0) double mindful,
    @JsonKey(name: "body-mass-month") double? bodyMassMonth,
    @JsonKey(name: "body-mass-origin") double? bodyMassOrigin,
    @JsonKey(name: "body-mass-day-30") double? bodyMassDay30,
    @JsonKey(name: "global-cut") double? globalCut,
    @JsonKey(name: "global-active") double? globalActive,
    @JsonKey(name: "acc-active") double? accActive,
    @JsonKey(name: "acc-mindful") double? accMindful,
    @JsonKey(name: "marvel-mindful") double? marvelMindful,
    @JsonKey(name: "marvel-active") double? marvelActive,
    @Default(0.0) double exercise,
    @Default(0.0) double active,
    @Default(0.0) double rest,
  }) = _DashFit;

  factory DashFit.fromJson(Map<String, dynamic> json) =>
      _$DashFitFromJson(json);
}

@freezed
class DashTemp with _$DashTemp {
  const factory DashTemp(
      {@Default(0.0) double high,
      @Default(0.0) double low,
      @Default(0.0) double diffHigh,
      @Default(0.0) double diffLow}) = _DashTemp;

  factory DashTemp.fromJson(Map<String, dynamic> json) =>
      _$DashTempFromJson(json);
}

@freezed
class DashTodo with _$DashTodo {
  const factory DashTodo(
      {@Default("") String title,
      @JsonKey(name: "create_at") @Default("") String createAt,
      @Default(false) bool isFinished}) = _DashTodo;

  factory DashTodo.fromJson(Map<String, dynamic> json) =>
      _$DashTodoFromJson(json);
}

@freezed
class DashWeatherIcon with _$DashWeatherIcon {
  const factory DashWeatherIcon(
          {@Default("") String date,
          @Default(WeatherIconType.UNKNOWN) WeatherIconType value}) =
      _DashWeatherIcon;

  factory DashWeatherIcon.fromJson(Map<String, dynamic> json) =>
      _$DashWeatherIconFromJson(json);
}

enum WeatherIconType {
  CLEAR_DAY(name: "晴（白天）"),
  CLEAR_NIGHT(name: "晴（夜间）"),
  PARTLY_CLOUDY_DAY(name: "多云（白天）"),
  PARTLY_CLOUDY_NIGHT(name: "多云（夜间）"),
  CLOUDY(name: "阴"),
  LIGHT_HAZE(name: "轻度雾霾"),
  MODERATE_HAZE(name: "中度雾霾"),
  HEAVY_HAZE(name: "重度雾霾"),
  LIGHT_RAIN(name: "小雨"),
  MODERATE_RAIN(name: "中雨"),
  HEAVY_RAIN(name: "大雨"),
  STORM_RAIN(name: "暴雨"),
  FOG(name: "雾"),
  LIGHT_SNOW(name: "小雪"),
  MODERATE_SNOW(name: "中雪"),
  HEAVY_SNOW(name: "大雪"),
  STORM_SNOW(name: "暴雪"),
  DUST(name: "浮尘"),
  SAND(name: "沙尘"),
  WIND(name: "大风"),
  UNKNOWN(name: "未知");

  final String name;
  const WeatherIconType({required this.name});
  bool get showRain =>
      this == LIGHT_RAIN ||
      this == MODERATE_RAIN ||
      this == HEAVY_RAIN ||
      this == STORM_RAIN ||
      this == LIGHT_SNOW ||
      this == MODERATE_SNOW ||
      this == HEAVY_SNOW ||
      this == STORM_SNOW;
}

@freezed
class DashInfo with _$DashInfo {
  factory DashInfo(
      {@Default(0) int updateAt,
      @Default(false) bool needDiaryReport,
      @Default("") String weatherInfo,
      @Default(DashWeatherIcon(date: "", value: WeatherIconType.UNKNOWN))
      DashWeatherIcon weatherIcon,
      @Default(false) bool needPlantWater,
      @Default([]) List<String> cardCheck,
      @Default([]) List<DashTodo> todo,
      @Default(false) bool offWork,
      @Default("") String workStatus,
      @Default(DashTemp()) DashTemp tempInfo,
      @Default(DashTemp()) DashTemp tempFutureInfo,
      @Default(DashFit()) DashFit fitnessInfo,
      @Default("") String debugInfo,
      @Default("") String lastError,
      @Default([]) List<DashExpress> express}) = _DashInfo;

  factory DashInfo.fromJson(Map<String, dynamic> json) =>
      _$DashInfoFromJson(json);
}

extension DashInfoExt on DashInfo {
  bool get lazyLate {
    final workout100 = max((fitnessInfo.active), 50) /
        (fitnessInfo.globalActive ?? 500.0) *
        100;
    final now = DateTime.now();
    return now.hour >= 18 && workout100 < 100;
  }
}

@freezed
class DashExpress with _$DashExpress {
  factory DashExpress({
    @Default("") String id,
    @Default("") String name,
    @Default(0) int status,
    @Default("") @JsonKey(name: "last_update") String lastUpdate,
    @Default("") String info,
    @Default([]) List<DashExpressExtra> extra,
  }) = _DashExpress;

  factory DashExpress.fromJson(Map<String, dynamic> json) =>
      _$DashExpressFromJson(json);
}

@freezed
class DashExpressExtra with _$DashExpressExtra {
  const factory DashExpressExtra(
      {@Default("") String time, @Default("") status}) = _DashExpressExtra;
  factory DashExpressExtra.fromJson(Map<String, dynamic> json) =>
      _$DashExpressExtraFromJson(json);
}

@riverpod
Future<List<DashExpress>> getExpress(Ref ref) async {
  final (res, ok) = await requestFromList("/cyber/express/recent",
      (p) => p.map((e) => DashExpress.fromJson(e)).toList(growable: false));
  if (ok.isNotEmpty) {
    debugPrint(ok);
  }
  return res ?? [];
}

@riverpod
Future<DashInfo> getDash(Ref ref) async {
  final c = ref.read(configsProvider).value;
  if (c?.demoMode ?? true) {
    return fakeDashInfo();
  }
  debugPrint("req for dash");
  try {
    final express = await ref.refresh(getExpressProvider.future);
    final (res, d) =
        await requestFromRaw("/cyber/client/ios-widget", DashInfo.fromJson);
    return res?.copyWith(
            express: express,
            debugInfo:
                "[normal] ver: $version, req: ${Configs.data.copyWith(password: "***")}") ??
        DashInfo(
            express: express,
            debugInfo:
                "[empty] ver: $version, req: ${Configs.data.copyWith(password: "***")}, origin or err $d",
            lastError: d);
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return DashInfo(
        debugInfo:
            "[error] ver: $version, error: $e, stack: ${st.toString()}, req ${Configs.data.copyWith(password: "***")}",
        lastError: e.toString());
  }
}

DashInfo fakeDashInfo() {
  return DashInfo(
      weatherInfo: Random().nextBool() ? "今天的天气晴朗，平均气温 23°" : "最近的降雨带在 20 公里以外",
      todo: [
        const DashTodo(title: "阅读《小王子》"),
        const DashTodo(title: "双击时钟打开设置界面"),
        DashTodo(title: "取快递", isFinished: Random().nextBool())
      ],
      offWork: Random().nextBool(),
      workStatus: (["🔴", "🟡", "🟢", "⚫", "⚪"]..shuffle()).first,
      fitnessInfo: DashFit(
          exercise: Random().nextDouble() * 10 + 10,
          active: Random().nextDouble() * 80 + 200,
          mindful: Random().nextInt(3) + 1),
      debugInfo:
          "[demo] ver: $version, req: ${Configs.data.copyWith(password: "***", cyberPass: "***")}");
}

@riverpod
class Times extends _$Times {
  @override
  Stream<int> build() {
    return Stream.periodic(const Duration(seconds: 1), (a) {
      return a;
    });
  }
}
