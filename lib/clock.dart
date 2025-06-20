import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screen_me/api/dash.dart';

import 'api/core.dart';

class ClockWidget extends ConsumerStatefulWidget {
  final AnimationController controller;
  final Config config;

  const ClockWidget(
      {super.key, required this.controller, required this.config});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget> {
  static const size = 100.0;
  late Widget time = buildTimeWidget(time: "");

  Widget buildTimeWidget({String? time, double opacity = 0.9}) {
    if (widget.config.fontType == FontType.playfair) {
      return Transform.translate(
        offset: const Offset(0, -18),
        child: Text(time ?? DateFormat("HH:mm").format(DateTime.now()),
            style: TextStyle(
                fontFamily: "PlayfairDisplay",
                fontSize: size,
                fontWeight: FontWeight.w700,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(opacity))),
      );
    } else if (widget.config.fontType == FontType.orbitron) {
      return Padding(
        padding: const EdgeInsets.only(top: 0, right: 10, bottom: 10),
        child: Text(time ?? DateFormat("HH:mm").format(DateTime.now()),
            style: TextStyle(
                fontFamily: "Orbitron",
                fontSize: size - 12,
                fontWeight: FontWeight.w700,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(opacity))),
      );
    } else if (widget.config.fontType == FontType.plex) {
      return Text(time ?? DateFormat("HH:mm").format(DateTime.now()),
          style: TextStyle(
              fontFamily: "Plex",
              fontSize: size - 12,
              fontWeight: FontWeight.w800,
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(opacity)));
    }
    return Text(time ?? DateFormat("HH:mm").format(DateTime.now()),
        style: TextStyle(
            fontFamily: "DoHyen",
            fontSize: size,
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(opacity)));
  }

  @override
  Widget build(BuildContext context) {
    var dash = ref.watch(getDashProvider).value ?? DashInfo();
    ref.listen(timesProvider, (previous, t) {
      if ((t.value ?? -1) % Configs.data.fetchSeconds == 0) {
        widget.controller.forward(from: 0);
        time = buildTimeWidget(opacity: 0.5);
        ref.invalidate(getDashProvider);
      } else {
        time = buildTimeWidget(opacity: 0.9);
        setState(() {});
      }
    });
    final todo = [...dash.todo];
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
