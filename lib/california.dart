import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;

class CaliforniaClockView extends ConsumerStatefulWidget {
  const CaliforniaClockView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CaliforniaClockViewState();
}

class _CaliforniaClockViewState extends ConsumerState<CaliforniaClockView> {
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: _CaliforniaClockPainter(dateTime: _now),
        size: Size.infinite,
      ),
    );
  }
}

class _CaliforniaClockPainter extends CustomPainter {
  final DateTime dateTime;
  final List<String> _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  _CaliforniaClockPainter({required this.dateTime});

  static final Map<String, List<Offset>> _pointCache = {};

  List<Offset> _getEvenlySpacedPoints(int numPoints, double rx, double ry,
      double cornerRounding, Offset center) {
    final key = "$numPoints:$rx:$ry:$cornerRounding";
    if (_pointCache.containsKey(key)) {
      return _pointCache[key]!.map((p) => p + center).toList();
    }

    final List<Offset> perimeterPoints = [];
    final List<double> cumulativeDistances = [0.0];
    double totalDistance = 0;

    final int resolution = 3600;
    Offset? lastPoint;

    for (int i = 0; i <= resolution; i++) {
      final angle = i * 2 * pi / resolution;
      final cosAngle = cos(angle);
      final sinAngle = sin(angle);
      final distToEdge = 1 /
          pow(
              pow((cosAngle).abs() / rx, cornerRounding) +
                  pow((sinAngle).abs() / ry, cornerRounding),
              1 / cornerRounding);
      final currentPoint = Offset(cosAngle * distToEdge, sinAngle * distToEdge);
      perimeterPoints.add(currentPoint);

      if (lastPoint != null) {
        final distance = (currentPoint - lastPoint).distance;
        totalDistance += distance;
        cumulativeDistances.add(totalDistance);
      }
      lastPoint = currentPoint;
    }

    final List<Offset> evenlySpacedPoints = [];
    final double segmentLength = totalDistance / numPoints;
    int perimeterIndex = 1;

    for (int i = 0; i < numPoints; i++) {
      final targetDistance = i * segmentLength;

      while (perimeterIndex < cumulativeDistances.length - 1 &&
          cumulativeDistances[perimeterIndex] < targetDistance) {
        perimeterIndex++;
      }

      final prevDist = cumulativeDistances[perimeterIndex - 1];
      final nextDist = cumulativeDistances[perimeterIndex];
      final prevPoint = perimeterPoints[perimeterIndex - 1];
      final nextPoint = perimeterPoints[perimeterIndex];

      final t = (nextDist - prevDist) > 1e-6
          ? (targetDistance - prevDist) / (nextDist - prevDist)
          : 0;
      final interpolatedPoint = Offset.lerp(prevPoint, nextPoint, t.toDouble())!;
      evenlySpacedPoints.add(interpolatedPoint);
    }

    _pointCache[key] = evenlySpacedPoints;
    return evenlySpacedPoints.map((p) => p + center).toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rx = size.width / 2;
    final ry = size.height / 2;
    final radius = min(rx, ry);

    _drawTicks(canvas, center, rx, ry, radius);
    _drawDate(canvas, center, ry, radius);
    _drawHands(canvas, center, radius);
  }

  void _drawTicks(
      Canvas canvas, Offset center, double rx, double ry, double radius) {
    final tickPaint = Paint()..color = const Color(0xFFC4D2D8);
    const cornerRounding = 10.0;

    final tickPoints = _getEvenlySpacedPoints(
        60, rx * 0.9, ry * 0.9, cornerRounding, center);

    for (int i = 0; i < tickPoints.length; i++) {
      final position = tickPoints[i];
      final angle =
          atan2(position.dy - center.dy, position.dx - center.dx) + pi / 2;

      final isHour = i % 5 == 0;
      final tickLength = isHour ? radius * 0.06 : radius * 0.03;
      final tickWidth = isHour ? radius * 0.02 : radius * 0.01;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset.zero, width: tickWidth, height: tickLength),
              Radius.circular(tickWidth / 2)),
          tickPaint);
      canvas.restore();
    }

    final textStyle = TextStyle(
        color: const Color(0xFFC4D2D8),
        fontSize: radius * 0.15,
        fontFamily: 'PlayfairDisplay');

    final hourMarkerPoints = _getEvenlySpacedPoints(
        12, rx * 0.75, ry * 0.75, cornerRounding, center);

    final hourMap = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2];

    for (int i = 0; i < hourMarkerPoints.length; i++) {
      final position = hourMarkerPoints[i];
      final hourNumber = hourMap[i];
      String? text;

      switch (hourNumber) {
        case 10:
          text = 'X';
          break;
        case 11:
          text = 'XI';
          break;
        case 1:
          text = 'I';
          break;
        case 2:
          text = 'II';
          break;
        case 4:
          text = '4';
          break;
        case 5:
          text = '5';
          break;
        case 7:
          text = '7';
          break;
        case 8:
          text = '8';
          break;
        case 3:
        case 9:
          final barWidth = radius * 0.2;
          final barHeight = radius * 0.05;
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromCenter(
                      center: position, width: barWidth, height: barHeight),
                  Radius.circular(barHeight / 2)),
              Paint()..color = const Color(0xFFC4D2D8));
          break;
        case 6:
          final barWidth = radius * 0.2;
          final barHeight = radius * 0.05;
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromCenter(
                      center: position, width: barWidth, height: barHeight),
                  Radius.circular(barHeight / 2)),
              Paint()..color = const Color(0xFFC4D2D8));
          break;
        case 12:
          final path = Path();
          final h = radius * 0.1;
          final w = radius * 0.12;
          path.moveTo(position.dx, position.dy + h / 2);
          path.lineTo(position.dx - w / 2, position.dy - h / 2);
          path.lineTo(position.dx + w / 2, position.dy - h / 2);
          path.close();
          canvas.drawPath(path, Paint()..color = const Color(0xFFAEC4D0));
          break;
      }

      if (text != null) {
        final textSpan = TextSpan(text: text, style: textStyle);
        final textPainter =
            TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
        textPainter.layout();
        textPainter.paint(canvas,
            position - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }
  }

  void _drawDate(Canvas canvas, Offset center, double ry, double radius) {
    final day = dateTime.day;
    final weekday = _weekdays[dateTime.weekday - 1];
    final dateText = '$day 周$weekday';

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: radius * 0.1,
      fontFamily: 'DoHyeon',
    );
    final textSpan = TextSpan(text: dateText, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    textPainter.layout();

    final position = center + Offset(0, ry * 0.25);
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawHands(Canvas canvas, Offset center, double radius) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final second = dateTime.second;

    // Hour hand
    final hourAngle = (hour % 12 + minute / 60) * 30 * pi / 180 - pi / 2;
    final hourHandLength = radius * 0.45;
    final hourHandWidth = radius * 0.08;
    final hourHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final hourHandOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final hourHandPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(hourHandLength / 2, 0),
            width: hourHandLength,
            height: hourHandWidth),
        Radius.circular(hourHandWidth / 2),
      ));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(hourAngle);
    canvas.drawPath(hourHandPath, hourHandPaint);
    canvas.drawPath(hourHandPath, hourHandOutlinePaint);
    canvas.restore();

    // Minute hand
    final minuteAngle = (minute + second / 60) * 6 * pi / 180 - pi / 2;
    final minuteHandLength = radius * 0.7;
    final minuteHandWidth = radius * 0.05;
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final minuteHandOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final minuteHandPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(minuteHandLength / 2, 0),
            width: minuteHandLength,
            height: minuteHandWidth),
        Radius.circular(minuteHandWidth / 2),
      ));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(minuteAngle);
    canvas.drawPath(minuteHandPath, minuteHandPaint);
    canvas.drawPath(minuteHandPath, minuteHandOutlinePaint);
    canvas.restore();

    // Second hand
    final secondAngle = second * 6 * pi / 180 - pi / 2;
    final secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = radius * 0.01
      ..strokeCap = StrokeCap.round;
    final secondHandStart = center +
        Offset(cos(secondAngle) * -radius * 0.15,
            sin(secondAngle) * -radius * 0.15);
    final secondHandEnd = center +
        Offset(
            cos(secondAngle) * radius * 0.8, sin(secondAngle) * radius * 0.8);
    canvas.drawLine(secondHandStart, secondHandEnd, secondHandPaint);

    // Center circle
    canvas.drawCircle(center, radius * 0.03, Paint()..color = Colors.red);
    canvas.drawCircle(center, radius * 0.015, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _CaliforniaClockPainter oldDelegate) {
    return dateTime != oldDelegate.dateTime;
  }
}