import 'package:flutter/material.dart';

enum WarnType {
  eye(position: Offset(130, 0), cnName: "眼睛", path: "assets/eye.json"),
  yoga(position: Offset(160, 10), cnName: "瑜伽", path: "assets/yoga.json"),
  water(position: Offset(180, 10), cnName: "气泡", path: "assets/orange.json"),
  gallery(position: Offset(0, 0), cnName: "画廊", path: ""),
  //random 必须为最后一个
  random(position: Offset(0, 0), cnName: "随机", path: "assets/random.json");

  final Offset position;
  final String cnName;
  final String path;

  const WarnType(
      {required this.position, required this.cnName, required this.path});
}

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
  bing(name: "Bing 壁纸"),
  gallery(name: "画廊"),
  fit(name: "健身圆环"),
  warning(name: "健身警告");

  final String name;
  const FaceType({required this.name});
}
