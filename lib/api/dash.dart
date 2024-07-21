// ignore_for_file: invalid_annotation_target

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_me/api/common.dart';
import 'package:screen_me/version.dart';

part 'dash.freezed.dart';
part 'dash.g.dart';

enum WarnType {
  eye(position: Offset(130, 0), cnName: "眼睛", path: "assets/eye.json"),
  yoga(position: Offset(160, 10), cnName: "瑜伽", path: "assets/yoga.json"),
  water(position: Offset(180, 10), cnName: "气泡", path: "assets/orange.json"),
  gallery(position: Offset(0, 0), cnName: "画廊", path: ""),
  //random 必须为最后一个
  random(position: Offset(0, 0), cnName: "随机", path: "assets/random.json");

  final Offset position;
  final String cnName;
  final String path;

  const WarnType(
      {required this.position, required this.cnName, required this.path});
}

enum FaceType {
  bing(name: "Bing 壁纸"),
  gallery(name: "画廊"),
  fit(name: "健身圆环"),
  warning(name: "健身警告");

  final String name;
  const FaceType({required this.name});
}

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
Future<List<DashExpress>> getExpress(GetExpressRef ref) async {
  final (res, ok) = await requestFromList("/cyber/express/recent",
      (p) => p.map((e) => DashExpress.fromJson(e)).toList(growable: false));
  if (ok.isNotEmpty) {
    debugPrint(ok);
  }
  return res ?? [];
}

@riverpod
Future<DashInfo> getDash(GetDashRef ref) async {
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

@freezed
class FaceGallery with _$FaceGallery {
  factory FaceGallery(
      {@Default(0.5) double blurOpacity,
      @Default(10.0) double borderRadius,
      @Default(1) int imageRepeatEachMinutes,
      @Default([]) List<String> images}) = _FaceGallery;

  factory FaceGallery.fromJson(Map<String, dynamic> json) =>
      _$FaceGalleryFromJson(json);
}

const faceGalleryUrl = "https://mazhangjing.com/service/screenMe/gallery.json";

extension FaceGalleryExt on FaceGallery {
  String get imageNow {
    if (images.isEmpty) return "";
    DateTime now = DateTime.now();
    int minutesSinceMidnight = now.hour * 60 + now.minute;
    int interval = minutesSinceMidnight ~/ imageRepeatEachMinutes;
    int index = interval % images.length;
    return images[index];
  }
}

@riverpod
Future<FaceGallery> getFaceGallery(GetFaceGalleryRef ref) async {
  final s = await ref.watch(configsProvider.future);
  if (s.demoMode) {
    return FaceGallery(images: [
      "https://static2.mazhangjing.com/cyber/202407/9bb21ff6_photo-1721296382202-8b917fd0963e.jpg"
    ]);
  }
  try {
    final r = await get(Uri.parse(faceGalleryUrl),
        headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    return FaceGallery.fromJson(d);
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
  }
  return FaceGallery();
}
