import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_me/api/dash.dart';
import 'package:screen_me/blue.dart';
import 'package:screen_me/california.dart';
import 'package:screen_me/chart.dart';
import 'package:screen_me/express.dart';
import 'package:screen_me/gallery.dart';
import 'package:screen_me/setting.dart';

import 'api/core.dart';
import 'clock.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with TickerProviderStateMixin {
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
                imageUrl: bingImageUrl,
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
        return GalleryView();
      case FaceType.clock:
        return CaliforniaClockView();
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
              buildFace(s.face),
              if (s.face.needClockTodoRain)
                Positioned(
                    left: 30,
                    top: 10,
                    bottom: 10,
                    child: ClockWidget(
                        config: s,
                        key: const ValueKey("clock"),
                        dash: d,
                        controller: controller)),
              if (s.face.needBlueExpress)
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
                    ])),
              if (s.needDarkNow)
                Positioned.fill(
                    child: Container(
                        color: Colors.black.withValues(alpha: s.darkness))),
            ])));
  }
}
