import 'dart:io';

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

num abs(num a) {
  return a > 0 ? a : -a;
}

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(configsProvider).value ?? Config();
    final d = ref.watch(getDashProvider).value;
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";
    var eyeDataOK = s.showFatWarningAfter17IfLazy && (d?.lazyLate ?? false);
    //eyeDataOK = true;
    final showBing = s.showBingWallpaper &&
        !(eyeDataOK && s.fatWarningOverwriteBingWallpaper);
    final showEye = !showBing && eyeDataOK;
    final showFitness = !showBing && !eyeDataOK;
    return Scaffold(
        endDrawer: const Drawer(child: ExpressView()),
        backgroundColor: Colors.black,
        body: GestureDetector(
            onHorizontalDragEnd: (details) async {
              final offset = details.velocity.pixelsPerSecond;
              if (abs(offset.dx) > 10 || abs(offset.dy) > 10) {
                await ref.read(configsProvider.notifier).changeFace();
              }
            },
            onLongPress: () => showDebugBar(context, d?.debugInfo),
            onDoubleTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingView())),
            child: Stack(fit: StackFit.expand, children: [
              Positioned.fill(
                  child: showBing
                      ? CachedNetworkImage(
                              imageUrl:
                                  "https://go.mazhangjing.com/bing-today-image?normal=true",
                              cacheKey: "bing-today-image-$today",
                              fit: BoxFit.cover)
                          .animate()
                          .fadeIn()
                      : const SizedBox()),
              if (showEye)
                Transform.translate(
                    offset: s.warningType.position, //130 160 180,10
                    child: LottieBuilder.asset(s.warningType.path,
                        alignment: Alignment.center,
                        frameRate: FrameRate(60),
                        controller: controller)),
              Positioned(
                  left: 30,
                  top: 10,
                  bottom: 10,
                  child: ClockWidget(
                      key: const ValueKey("clock"), controller: controller)),
              Positioned(
                  bottom: 0, left: 20, child: buildLoadingAnimation(s, d)),
              Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: showFitness
                      ? Transform.scale(
                          scale: 1.1,
                          child: Transform.translate(
                              offset: const Offset(40, 20),
                              child: buildChart(d, s)
                                  .animate()
                                  .moveX(begin: 10, end: 0)))
                      : const SizedBox()),
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
    final needShow =
        s.showLoadingAnimationIfNoTodo && (d?.todo.isEmpty ?? true);
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
