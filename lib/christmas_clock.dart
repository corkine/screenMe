import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChristmasClockView extends ConsumerStatefulWidget {
  const ChristmasClockView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChristmasClockViewState();
}

class _ChristmasClockViewState extends ConsumerState<ChristmasClockView>
    with TickerProviderStateMixin {
  DateTime _now = DateTime.now();
  Timer? _timer;
  bool _showColon = true;
  final List<Snowflake> _snowflakes = [];
  late AnimationController _snowController;
  late AnimationController _lightController;
  double _lightOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
          _showColon = !_showColon;
        });
      }
    });

    // 初始化雪花
    for (int i = 0; i < 60; i++) {
      _snowflakes.add(Snowflake());
    }

    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
        for (var flake in _snowflakes) {
          flake.update();
        }
        setState(() {});
      });

    _snowController.repeat();

    // 圣诞树灯光闪烁控制器
    _lightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
          _lightOpacity = 0.3 + _lightController.value * 0.7;
        });
      });
    _lightController.repeat(reverse: true, count: 10);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _snowController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  // 判断是否是偶数分钟
  bool get _needFlash => _now.minute == 0 || _now.minute == 30;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hour = _now.hour.toString().padLeft(2, '0');
    final minute = _now.minute.toString().padLeft(2, '0');
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final dateStr =
        '${_now.year}-${_now.month.toString().padLeft(2, '0')}-${_now.day.toString().padLeft(2, '0')}';
    final weekStr = weekdays[_now.weekday - 1].toUpperCase();

    // 根据屏幕尺寸计算字体大小
    final fontSize = size.width > 400 ? 240.0 : 200.0;
    final lineHeight = 0.5;

    return Container(
      color: const Color(0xFFAA5A4A), // 红棕色背景
      child: Stack(
        children: [
          // 圣诞树 - 右侧背景
          Positioned(
            right: -20,
            bottom: 30,
            child: Opacity(
              opacity: 0.6,
              child: CustomPaint(
                painter: PixelChristmasTreePainter(
                  lightOpacity: _needFlash ? _lightOpacity : 1.0,
                ),
                size: Size(size.width * 0.45, size.height * 0.7),
              ),
            ),
          ),
          // 雪花层
          CustomPaint(
            painter: SnowPainter(_snowflakes, size),
            size: size,
          ),
          // 主内容 - 时钟居中，日期与时钟左对齐
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 像素时钟 - 使用 Micro5 字体
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      hour,
                      style: TextStyle(
                        fontFamily: 'Micro5',
                        fontSize: fontSize,
                        height: lineHeight,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _showColon ? 1.0 : 0.3,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontFamily: 'Micro5',
                          fontSize: fontSize - 20,
                          height: lineHeight,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      minute,
                      style: TextStyle(
                        fontFamily: 'Micro5',
                        fontSize: fontSize,
                        height: lineHeight,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 日期信息
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A84B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: Color(0xFF8B4513),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Orbitron',
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        weekStr,
                        style: const TextStyle(
                          color: Color(0xFF8B4513),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Orbitron',
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 雪花类
class Snowflake {
  double x = 0;
  double y = 0;
  double size = 0;
  double speed = 0;
  double drift = 0;
  double opacity = 0;

  Snowflake() {
    reset(initialY: Random().nextDouble());
  }

  void reset({double initialY = 0}) {
    final random = Random();
    x = random.nextDouble();
    y = initialY;
    size = random.nextDouble() * 6 + 4; // 4-10 像素大小
    speed = random.nextDouble() * 0.003 + 0.001;
    drift = (random.nextDouble() - 0.5) * 0.002;
    opacity = random.nextDouble() * 0.5 + 0.3;
  }

  void update() {
    y += speed;
    x += drift;
    if (y > 1.1) {
      reset();
      y = -0.1;
    }
    if (x < -0.1) x = 1.1;
    if (x > 1.1) x = -0.1;
  }
}

// 雪花绘制器
class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final Size screenSize;

  SnowPainter(this.snowflakes, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in snowflakes) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: flake.opacity)
        ..style = PaintingStyle.fill;

      // 像素风格的雪花 - 绘制小方块
      final pixelSize = flake.size;
      final x = flake.x * screenSize.width;
      final y = flake.y * screenSize.height;

      canvas.drawRect(
        Rect.fromLTWH(x, y, pixelSize, pixelSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 像素圣诞树绘制器
class PixelChristmasTreePainter extends CustomPainter {
  final double lightOpacity;

  PixelChristmasTreePainter({this.lightOpacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 15;

    // 圣诞树像素图案
    // 0: 透明, 1: 深绿, 2: 浅绿, 3: 黄色(星星/装饰), 4: 红色(装饰), 5: 棕色(树干), 6: 白色(装饰)
    final treePattern = [
      [0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0], // 星星
      [0, 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0, 0, 0, 0], // 星星
      [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 2, 3, 2, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 2, 1, 2, 1, 2, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 2, 1, 2, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 2, 4, 2, 1, 2, 1, 0, 0, 0, 0],
      [0, 0, 0, 1, 2, 1, 2, 1, 2, 6, 2, 1, 0, 0, 0],
      [0, 0, 1, 2, 3, 2, 1, 2, 1, 2, 1, 2, 1, 0, 0],
      [0, 0, 0, 1, 2, 1, 2, 1, 2, 1, 2, 1, 0, 0, 0],
      [0, 0, 1, 2, 1, 6, 1, 2, 1, 4, 1, 2, 1, 0, 0],
      [0, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 0],
      [1, 2, 1, 3, 1, 2, 1, 2, 1, 2, 6, 1, 2, 1, 1],
      [0, 0, 0, 0, 0, 0, 5, 5, 5, 0, 0, 0, 0, 0, 0], // 树干
      [0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0], // 树干
    ];

    // 灯光颜色（会闪烁）: 3-黄色, 4-红色, 6-白色
    final lightColors = {3, 4, 6};

    final colors = {
      0: Colors.transparent,
      1: const Color(0xFF1B7F37), // 深绿
      2: const Color(0xFF3CB371), // 浅绿
      3: const Color(0xFFFFD700), // 金黄色
      4: const Color(0xFFFF4444), // 红色
      5: const Color(0xFF8B4513), // 棕色
      6: const Color(0xFFFFFFFF), // 白色
    };

    for (int row = 0; row < treePattern.length; row++) {
      for (int col = 0; col < treePattern[row].length; col++) {
        final colorIndex = treePattern[row][col];
        if (colorIndex != 0) {
          final baseColor = colors[colorIndex]!;
          final color = lightColors.contains(colorIndex)
              ? baseColor.withOpacity(lightOpacity)
              : baseColor;

          final paint = Paint()
            ..color = color
            ..style = PaintingStyle.fill;

          canvas.drawRect(
            Rect.fromLTWH(
              col * pixelSize,
              row * pixelSize,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelChristmasTreePainter oldDelegate) =>
      oldDelegate.lightOpacity != lightOpacity;
}
