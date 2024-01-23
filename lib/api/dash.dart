// ignore_for_file: invalid_annotation_target

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_me/api/common.dart';
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
class DashInfo with _$DashInfo {
  factory DashInfo(
      {@Default(0) int updateAt,
      @Default(false) bool needDiaryReport,
      @Default("") String weatherInfo,
      @Default(false) bool needPlantWater,
      @Default([]) List<String> cardCheck,
      @Default([]) List<DashTodo> todo,
      @Default(false) bool offWork,
      @Default("") String workStatus,
      @Default(DashTemp()) DashTemp tempInfo,
      @Default(DashTemp()) DashTemp tempFutureInfo,
      @Default(DashFit()) DashFit fitnessInfo,
      @Default("") String debugInfo,
      @Default("") String lastError}) = _DashInfo;

  factory DashInfo.fromJson(Map<String, dynamic> json) =>
      _$DashInfoFromJson(json);
}

@riverpod
Future<DashInfo> getDash(GetDashRef ref) async {
  if (ref.read(configsProvider).value?.demoMode ?? false) {
    return fakeDashInfo();
  }
  debugPrint("req for dash");
  try {
    final (res, d) =
        await requestFromRaw("/cyber/client/ios-widget", DashInfo.fromJson);
    return res?.copyWith(
            debugInfo:
                "[normal] ver: $version, req: ${Configs.data.copyWith(password: "***")}") ??
        DashInfo(
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
