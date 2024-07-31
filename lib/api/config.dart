import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@freezed
class Config with _$Config {
  factory Config(
      {@Default("") String user,
      @Default("") String password,
      @Default(60) int fetchSeconds,
      @Default(FaceType.bing) FaceType face,
      @Default("") String cyberPass,
      @Default(true) bool demoMode,
      @Default(true) bool useAnimationWhenNoTodo,
      @Default(20.0) double maxVolDelaySeconds,
      @Default(false) bool showFatWarningAfter17IfLazy,
      @Default(WarnType.eye) WarnType warningType,
      @Default(false) bool warningShowGalleryInBg,
      @Default(RainType.cloud) RainType rainType,
      @Default(0.1) double volumeNormal,
      @Default(0.7) double volumeOpenBluetooth}) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}

extension ConfigHelper on Config {
  String get base64Token =>
      "Basic ${base64Encode(utf8.encode('$user:$password'))}";

  Map<String, String> get base64Header =>
      <String, String>{'authorization': base64Token};

  String get cyberBase64Token =>
      "Basic ${base64Encode(utf8.encode('$user:$cyberPass'))}";

  Map<String, String> get cyberBase64Header =>
      <String, String>{'authorization': cyberBase64Token};

  Map<String, String> get cyberBase64JsonContentHeader => <String, String>{
        'Authorization': cyberBase64Token,
        'Content-Type': 'application/json'
      };

  int get changeSeconds => demoMode ? 10 : fetchSeconds;
}

@riverpod
class Configs extends _$Configs {
  static late Config data;
  @override
  Future<Config> build() async {
    data = await loadFromLocal();
    return data;
  }

  set(String user, String pass, int duration,
      {bool demoMode = false,
      bool useAnimationWhenNoTodo = false,
      required double minVol,
      required double maxVol,
      required bool showWortoutWarning,
      required bool warningShowGalleryInBg,
      required WarnType warningType,
      required RainType rainType,
      required FaceType face,
      double delay = 0.0}) async {
    final c = Config(
        user: user,
        password: pass,
        cyberPass: encryptPassword(pass, 60 * 60 * 24 * 30),
        fetchSeconds: duration,
        useAnimationWhenNoTodo: useAnimationWhenNoTodo,
        demoMode: demoMode,
        volumeNormal: minVol,
        volumeOpenBluetooth: maxVol,
        showFatWarningAfter17IfLazy: showWortoutWarning,
        warningShowGalleryInBg: warningShowGalleryInBg,
        face: face,
        rainType: rainType,
        warningType: warningType,
        maxVolDelaySeconds: delay);
    final s = await SharedPreferences.getInstance();
    await s.setString("config", jsonEncode(c.toJson()));
    data = c;
    state = AsyncData(c);
  }

  changeFace({reverse = false}) async {
    var v = state.value;
    if (v == null) return;
    final idx = reverse ? -1 : 1;
    final nextFace = FaceType.values[
        (FaceType.values.indexOf(v.face) + idx) % FaceType.values.length];
    v = v.copyWith(face: nextFace);
    final s = await SharedPreferences.getInstance();
    await s.setString("config", jsonEncode(v.toJson()));
    data = v;
    state = AsyncData(v);
  }

  static Future<Config> loadFromLocal() async {
    try {
      final s = await SharedPreferences.getInstance();
      final d = s.getString("config") ?? "{}";
      data = Config.fromJson(jsonDecode(d));
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      data = Config();
    }
    return data;
  }
}
