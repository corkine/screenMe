import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'common.dart';

part 'gallery.g.dart';
part 'gallery.freezed.dart';

@freezed
class FaceGallery with _$FaceGallery {
  factory FaceGallery(
      {@Default(0.5) double blurOpacity,
      double? blurOpacityInBgMode,
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
