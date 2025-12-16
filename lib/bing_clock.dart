import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'api/core.dart';

int cacheMinute = 0;

class BingClockView extends ConsumerStatefulWidget {
  const BingClockView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BingClockViewState();
}

class _BingClockViewState extends ConsumerState<BingClockView>
    with TickerProviderStateMixin {
  DateTime _now = DateTime.now();
  Timer? _timer;
  bool _showColon = true;
  late AnimationController rainController;

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
    rainController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    rainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configsProvider).value ?? Config();
    final fontType = config.fontType;
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";

    final hour = DateFormat('HH').format(_now);
    final minute = DateFormat('mm').format(_now);

    double offY = 0;
    double fontSize = 120;
    double offYTick = 0;
    double fontSizeTick = 120;
    Color color = Colors.white.withAlpha(230);
    switch (fontType) {
      case FontType.dohyeon:
        offY = 0;
        fontSize = 200;
        offYTick = -10;
        fontSizeTick = 200;
        break;
      case FontType.playfair:
        offY = -35;
        fontSize = 180;
        offYTick = 10;
        fontSizeTick = 130;
        break;
      case FontType.orbitron:
        offY = -10;
        fontSize = 120;
        offYTick = -10;
        fontSizeTick = 100;
        break;
      case FontType.plex:
        offY = -10;
        fontSize = 150;
        offYTick = -10;
        fontSizeTick = 150;
        break;
      case FontType.micro5:
        offY = -50;
        fontSize = 280;
        offYTick = 30;
        fontSizeTick = 200;
        break;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
            imageUrl: bingImageUrl,
            cacheKey: "bing-today-image-$today",
            fit: BoxFit.cover),
        // if (config.rainType != RainType.none)
        //   Positioned(
        //       top: 0,
        //       left: 0,
        //       bottom: 0,
        //       right: 0,
        //       child: LottieBuilder.asset(RainType.rain.path,
        //           controller: rainController)),
        Transform.translate(
          offset: Offset(0, offY),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(hour,
                    style: TextStyle(
                        fontSize: fontSize,
                        color: color,
                        fontFamily: fontType.fontFamily)),
                Transform.translate(
                  offset: Offset(0, offYTick),
                  child: AnimatedOpacity(
                    opacity: _showColon ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(":",
                        style: TextStyle(
                            fontSize: fontSizeTick,
                            color: color,
                            fontFamily: fontType.fontFamily)),
                  ),
                ),
                Text(minute,
                    style: TextStyle(
                        fontSize: fontSize,
                        color: color,
                        fontFamily: fontType.fontFamily)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
