import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screen_me/api/dash.dart';
import 'package:screen_me/blue.dart';
import 'package:screen_me/chart.dart';
import 'package:screen_me/setting.dart';

import 'api/common.dart';

num abs(num a) {
  return a > 0 ? a : -a;
}

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final s = ref.watch(configsProvider).value ?? Config();
    final d = ref.watch(getDashProvider).value;
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
            onHorizontalDragEnd: (details) async {
              final offset = details.velocity.pixelsPerSecond;
              if (abs(offset.dx) > 10 || abs(offset.dy) > 10) {
                await ref.read(configsProvider.notifier).changeFace();
              }
            },
            onLongPress: () => showDebugBar(context, d?.debugInfo ?? "没有诊断信息"),
            onDoubleTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingView())),
            child: Stack(fit: StackFit.expand, children: [
              ...(s.showBingWallpaper
                  ? [
                      Positioned.fill(
                          child: CachedNetworkImage(
                              imageUrl:
                                  "https://go.mazhangjing.com/bing-today-image?normal=true",
                              cacheKey: "bing-today-image-$today",
                              fit: BoxFit.cover))
                    ]
                  : []),
              const Positioned(
                  left: 30, top: 10, bottom: 10, child: ClockWidget()),
              ...(s.showBingWallpaper
                  ? []
                  : [
                      Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Transform.scale(
                              scale: 1.1,
                              child: Transform.translate(
                                  offset: const Offset(40, 20),
                                  child: buildChart(d))))
                    ]),
              Positioned(
                  right: 20,
                  bottom: 20,
                  child: Row(children: [
                    const BlueWidget(),
                    s.demoMode
                        ? const Text("演示模式",
                            style: TextStyle(color: Colors.white70))
                        : const SizedBox()
                  ]))
            ])));
  }
}

class ClockWidget extends ConsumerStatefulWidget {
  const ClockWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget> {
  static const size = 100.0;
  Widget time =
      const Text("", style: TextStyle(fontFamily: "DoHyen", fontSize: size));
  StreamController controller = StreamController();
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    controller.sink.addStream(
        Stream.periodic(const Duration(seconds: 1), (index) => index));
  }

  @override
  void didChangeDependencies() {
    debugPrint("register subscription now");
    subscription ??= controller.stream.listen(handleAction);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    debugPrint("cancel subscription");
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }

  handleAction(event) {
    final now = DateTime.now();
    final seconds = Configs.data.changeSeconds;
    if (event % seconds == 0) {
      debugPrint("invalidate dash $seconds");
      ref.invalidate(getDashProvider);
      time = Text(DateFormat("HH:mm").format(now),
          style: TextStyle(
              fontFamily: "DoHyen",
              fontSize: size,
              color: Colors.white.withOpacity(0.5)));
    } else {
      time = Text(DateFormat("HH:mm").format(now),
          style: const TextStyle(fontFamily: "DoHyen", fontSize: size));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dash = ref.watch(getDashProvider).value ?? DashInfo();
    final todo = [...dash.todo];
    // todo.sort((a, b) {
    //   if (a.isFinished == b.isFinished) return a.title.compareTo(b.title);
    //   if (a.isFinished) {
    //     return 1;
    //   } else {
    //     return -1;
    //   }
    // });
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomPaint(
              painter: WorkStatus(workStatus: dash.workStatus), child: time),
          Transform.translate(
              offset: const Offset(0, -22),
              child: Text(dash.weatherInfo,
                  style: const TextStyle(color: Colors.white54, fontSize: 13))),
          const Spacer(),
          ...todo
              .take(5)
              .map((e) => SizedBox(
                  width: 300,
                  child: Text(e.title,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: e.isFinished ? Colors.white54 : Colors.white,
                          decorationThickness: 1.5,
                          decorationColor:
                              e.isFinished ? Colors.white54 : Colors.white,
                          decoration: e.isFinished
                              ? TextDecoration.lineThrough
                              : null))))
              .toList(growable: false),
          const SizedBox(height: 20)
        ]);
  }
}

class WorkStatus extends CustomPainter {
  final String workStatus;

  WorkStatus({super.repaint, required this.workStatus});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 10.0;
    switch (workStatus) {
      case "🟢":
        p.color = Colors.green;
        break;
      case "🔴":
        p.color = Colors.red;
        break;
      case "🟠":
        p.color = Colors.orange;
        break;
      case "⚫️":
        p.color = Colors.black;
        break;
      case "⚪️":
        p.color = Colors.white;
        break;
      case "🟡":
        p.color = Colors.yellow;
        break;
      default:
        p.color = Colors.green;
    }
    p.color = p.color.withOpacity(1);
    canvas.drawCircle(Offset(size.width, size.height / 3), 20, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
