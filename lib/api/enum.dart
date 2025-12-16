import 'package:flutter/material.dart';

enum RainType {
  lotus(
      name: "荷花",
      position: Offset(0, 170),
      path: "assets/lotus.json",
      size: Size(160, 160)),
  cloud(
      name: "云朵",
      position: Offset(10, 225),
      path: "assets/cloud.json",
      size: Size(160, 160)),
  rain(
      name: "雨滴",
      position: Offset(0, 0),
      path: "assets/rain.json",
      size: Size(600, 400)),
  none(name: "不显示", position: Offset(0, 0), path: "", size: Size(0, 0));

  final String path;
  final Offset position;
  final Size size;
  final String name;
  const RainType(
      {required this.name,
      required this.position,
      required this.path,
      required this.size});
}

enum FaceType {
  bing(name: "Bing 壁纸", needClockTodoRain: true, needBlueExpress: true),
  gallery(name: "画廊", needClockTodoRain: true, needBlueExpress: true),
  fit(name: "健身", needClockTodoRain: true, needBlueExpress: true),
  clock(name: "加州时钟", needClockTodoRain: false, needBlueExpress: false),
  bingClock(name: "必应时钟", needClockTodoRain: false, needBlueExpress: false),
  christmas(name: "圣诞时钟", needClockTodoRain: false, needBlueExpress: false);

  final String name;
  final bool needClockTodoRain;
  final bool needBlueExpress;
  const FaceType(
      {required this.name,
      required this.needClockTodoRain,
      required this.needBlueExpress});
}

enum FontType {
  dohyeon(name: "DoHyen", fontFamily: "DoHyen"),
  playfair(name: "Playfair Display", fontFamily: "PlayfairDisplay"),
  orbitron(name: "Orbitron", fontFamily: "Orbitron"),
  plex(name: "Plex", fontFamily: "Plex"),
  micro5(name: "Micro5", fontFamily: "Micro5");

  final String name;
  final String fontFamily;
  const FontType({required this.name, required this.fontFamily});
}
