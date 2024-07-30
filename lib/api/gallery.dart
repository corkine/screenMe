import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core.dart';

part 'gallery.g.dart';
part 'gallery.freezed.dart';

/// see https://git.mazhangjing.com/corkine/cyberMeFlutter/lib/api/gallery.dart
@freezed
class FaceGallery with _$FaceGallery {
  factory FaceGallery(
      {@Default(0.7) double blurOpacity,
      @Default(0.3) double blurOpacityInBgMode,
      @Default(25) double borderRadius,
      @Default(5) int imageRepeatEachMinutes,
      @Default(1) int configRefreshMinutes,
      @Default([]) List<String> images, //已选择的图片
      @Default([]) List<String> imagesAll //所有的图片
      }) = _FaceGallery;

  factory FaceGallery.fromJson(Map<String, dynamic> json) =>
      _$FaceGalleryFromJson(json);
}

extension FaceGalleryExt on FaceGallery {
  String get imageNow {
    if (images.isEmpty) return "";
    DateTime now = DateTime.now();
    int minutesSinceMidnight = now.hour * 60 + now.minute;
    int interval = minutesSinceMidnight ~/ imageRepeatEachMinutes;
    int index = interval % images.length;
    return images[index];
  }

  (int, bool) get needRefreshGalleryConfig {
    if (configRefreshMinutes <= 0) return (0, false);
    DateTime now = DateTime.now();
    int min = now.hour * 60 + now.minute;
    if (min % configRefreshMinutes == 0) {
      return (min, true);
    }
    return (0, false);
  }
}

@riverpod
Future<FaceGallery> getFaceGallery(GetFaceGalleryRef ref) async {
  final s = await ref.watch(configsProvider.future);
  if (s.demoMode) {
    return FaceGallery(images: [fakeGalleryImage]);
  }
  try {
    final r = await get(Uri.parse(faceGalleryUrl),
        headers: Configs.data.cyberBase64Header);
    final d = jsonDecode(r.body);
    final re = FaceGallery.fromJson(d);
    debugPrint(
        "refreshed gallery config, images now ${re.images}, refresh next ${re.configRefreshMinutes}");
    return re;
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
  }
  return FaceGallery();
}
