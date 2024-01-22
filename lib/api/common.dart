import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
part 'common.freezed.dart';
part 'common.g.dart';

@freezed
class Config with _$Config {
  factory Config(
      {@Default("") String user,
      @Default("") String password,
      @Default(60) int fetchSeconds,
      @Default(false) bool showBingWallpaper,
      @Default("") String cyberPass}) = _Config;

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
}

@riverpod
class Configs extends _$Configs {
  static late Config data;
  @override
  Future<Config> build() async {
    data = await loadFromLocal();
    return data;
  }

  set(String user, String pass, int duration, bool showWallpaper) async {
    final c = Config(
        user: user,
        password: pass,
        cyberPass: encryptPassword(pass, 60 * 60 * 24 * 30),
        fetchSeconds: duration,
        showBingWallpaper: showWallpaper);
    final s = await SharedPreferences.getInstance();
    await s.setString("config", jsonEncode(c.toJson()));
    data = c;
    state = AsyncData(c);
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

const endpoint = kDebugMode
    ? "https://cyber.mazhangjing.com"
    : "https://cyber.mazhangjing.com";

String encryptPassword(String password, int validSeconds, [int? nowMill]) {
  var willExpired =
      (nowMill ?? DateTime.now().millisecondsSinceEpoch) + validSeconds * 1000;
  var digest = sha1.convert(utf8.encode("$password::$willExpired"));
  var passInSha1Base64 = base64Encode(digest.bytes);
  var res = base64Encode(utf8.encode("$passInSha1Base64::$willExpired"));
  return res;
}

String encodeSha1Base64(String plain) {
  var digest = sha1.convert(utf8.encode(plain));
  return base64Encode(digest.bytes);
}

Future<(T?, String)> requestFrom<T>(
    String path, T Function(Map<String, dynamic>) func) async {
  try {
    final url = "$endpoint$path";
    //debugPrint("request from $url");
    final r =
        await get(Uri.parse(url), headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    final code = (d["status"] as int?) ?? -1;
    //debugPrint("request from $url, data: $d, code $code");
    if (code <= 0) return (null, d["message"]?.toString() ?? "未知错误");
    final originData = d["data"];
    return (func(originData), "");
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return (null, e.toString());
  }
}

Future<(T?, String)> requestFromRaw<T>(
    String path, T Function(Map<String, dynamic>) func) async {
  try {
    final url = "$endpoint$path";
    //debugPrint("request from $url");
    final r =
        await get(Uri.parse(url), headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    //debugPrint("request from $url, data: $d, code $code");
    return (func(d), "");
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return (null, e.toString());
  }
}

Future<(T?, String)> requestFromType<T, Y>(
    String path, T Function(Y) func) async {
  try {
    final url = "$endpoint$path";
    //debugPrint("request from $url");
    final r =
        await get(Uri.parse(url), headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    final code = (d["status"] as int?) ?? -1;
    //debugPrint("request from $url, data: $d");
    if (code <= 0) return (null, d["message"]?.toString() ?? "未知错误");
    final originData = d["data"] as Y;
    return (func(originData), "");
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return (null, e.toString());
  }
}

Future<(bool, String)> postFrom<T>(
    String path, Map<String, dynamic> data) async {
  try {
    final url = "$endpoint$path";
    final r = await post(Uri.parse(url),
        headers: Configs.data.cyberBase64JsonContentHeader,
        body: jsonEncode(data));
    final d = jsonDecode(r.body);
    final code = (d["status"] as int?) ?? -1;
    //debugPrint("request from $url, data: $d");
    final msg = d["message"]?.toString() ?? "未知错误";
    if (code <= 0) return (false, msg);
    //final originData = d["data"];
    return (true, msg);
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return (false, e.toString());
  }
}

Future<(T?, String)> requestFromList<T>(
    String path, T Function(List<dynamic>) func) async {
  try {
    final url = "$endpoint$path";
    //debugPrint("request from $url");
    final r =
        await get(Uri.parse(url), headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    final code = (d["status"] as int?) ?? -1;
    //debugPrint("request from $url, data: $d");
    if (code <= 0) return (null, d["message"]?.toString() ?? "未知错误");
    final originData = d["data"];
    //debugPrint("data is $originData");
    return (func(originData), "");
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return (null, e.toString());
  }
}

showDebugBar(BuildContext context, dynamic e, {bool withPop = false}) {
  if (withPop) {
    Navigator.of(context).pop();
  }
  final sm = ScaffoldMessenger.of(context);
  sm.showMaterialBanner(MaterialBanner(
      content: GestureDetector(
          onTap: () => sm.clearMaterialBanners(),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(e.toString()))),
      actions: const [SizedBox()]));
}

showWaitingBar(BuildContext context,
    {String text = "正在刷新", Future Function()? func}) async {
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Row(children: [
        const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
        const SizedBox(width: 10),
        Text(text)
      ]),
      actions: const [SizedBox()]));
  if (func != null) {
    try {
      await func();
    } catch (_) {}
    ScaffoldMessenger.of(context).clearMaterialBanners();
  }
}

Future<bool> showSimpleMessage(BuildContext context,
    {String? title, required String content, bool withPopFirst = false}) async {
  if (withPopFirst) {
    Navigator.of(context).pop();
  }
  return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(title ?? "提示"),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("取消")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("确定"))
                ],
              )) ??
      false;
}
