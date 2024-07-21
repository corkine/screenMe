import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:screen_me/api/dash.dart';
import 'package:screen_me/blue.dart';
import 'package:screen_me/chart.dart';
import 'package:screen_me/express.dart';
import 'package:screen_me/setting.dart';

import 'api/common.dart';
import 'clock.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  DashInfo? d;
  late Config s;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  Widget buildFace(FaceType type) {
    switch (type) {
      case FaceType.bing:
        final now = DateTime.now();
        final today = "${now.year}-${now.month}-${now.day}";
        return CachedNetworkImage(
                imageUrl:
                    "https://go.mazhangjing.com/bing-today-image?normal=true",
                cacheKey: "bing-today-image-$today",
                fit: BoxFit.cover)
            .animate()
            .fadeIn();
      case FaceType.fit:
        return Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Transform.scale(
                scale: 1.1,
                child: Transform.translate(
                    offset: const Offset(40, 20),
                    child:
                        buildChart(d, s).animate().moveX(begin: 10, end: 0))));
      case FaceType.gallery:
        final fg = ref.watch(getFaceGalleryProvider).value ?? FaceGallery();
        final image = fg.imageNow;
        return KeyedSubtree(
            key: ValueKey(image),
            child: image.isNotEmpty
                ? Stack(fit: StackFit.expand, children: [
                    CachedNetworkImage(
                        imageUrl: image, cacheKey: image, fit: BoxFit.cover),
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                            color: Colors.black.withOpacity(fg.blurOpacity))),
                    Positioned(
                        right: 10,
                        top: 10,
                        bottom: 10,
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(fg.borderRadius),
                            child: CachedNetworkImage(
                                imageUrl: image,
                                cacheKey: image,
                                fit: BoxFit.fitWidth)))
                  ]).animate().fadeIn()
                : const SizedBox());
      case FaceType.warning:
        var wt = s.warningType;
        if (wt == WarnType.random) {
          wt = WarnType.values[Random().nextInt(WarnType.values.length - 1)];
        } else if (wt == WarnType.gallery) {
          return buildFace(FaceType.gallery);
        }
        return Transform.translate(
            offset: wt.position,
            child: LottieBuilder.asset(wt.path,
                alignment: Alignment.center,
                frameRate: FrameRate(60),
                controller: controller));
      default:
        return const Text("No Impl");
    }
  }

  FaceType computeNowFaceType() {
    var eyeDataOK = s.showFatWarningAfter17IfLazy && (d?.lazyLate ?? false);
    if (eyeDataOK) {
      return FaceType.warning;
    } else {
      return s.face;
    }
  }

  @override
  Widget build(BuildContext context) {
    s = ref.watch(configsProvider).value ?? Config();
    d = ref.watch(getDashProvider).value;
    return Scaffold(
        endDrawer: const Drawer(child: ExpressView()),
        backgroundColor: Colors.black,
        body: GestureDetector(
            onHorizontalDragEnd: (details) async {
              final offset = details.velocity.pixelsPerSecond;
              if (offset.dx > 10 || offset.dy > 10) {
                await ref.read(configsProvider.notifier).changeFace();
              } else if (offset.dx < -10 || offset.dy < -10) {
                await ref
                    .read(configsProvider.notifier)
                    .changeFace(reverse: true);
              }
            },
            onLongPress: () => showDebugBar(context, d?.debugInfo),
            onDoubleTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingView())),
            child: Stack(fit: StackFit.expand, children: [
              buildFace(computeNowFaceType()),
              Positioned(
                  left: 30,
                  top: 10,
                  bottom: 10,
                  child: ClockWidget(
                      key: const ValueKey("clock"), controller: controller)),
              Positioned(
                  bottom: 0, left: 20, child: buildLoadingAnimation(s, d)),
              Positioned(
                  right: 20,
                  bottom: 20,
                  child: Row(children: [
                    const BlueWidget(),
                    ExpressIcon(count: d?.express.length ?? 0),
                    s.demoMode
                        ? const Text("演示模式",
                            style: TextStyle(color: Colors.white70))
                        : const SizedBox()
                  ]))
            ])));
  }

  SizedBox buildLoadingAnimation(Config s, DashInfo? d) {
    final isNight = DateTime.now().hour >= 21;
    final needShow = s.useAnimationWhenNoTodo && (d?.todo.isEmpty ?? true);
    Widget? widget;
    if (needShow) {
      widget = LottieBuilder.asset(
          isNight ? "assets/ghost.json" : "assets/move.json",
          alignment: Alignment.center,
          frameRate: FrameRate(60),
          controller: controller);
    }
    // if (kDebugMode) {
    //   widget = LottieBuilder.asset("assets/ghost.json",
    //       alignment: Alignment.center, frameRate: FrameRate(60));
    // }
    return SizedBox(width: 100, height: 100, child: widget);
  }
}
