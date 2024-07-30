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

enum FaceType {
  bing(name: "Bing 壁纸"),
  gallery(name: "画廊"),
  fit(name: "健身圆环"),
  warning(name: "健身警告");

  final String name;
  const FaceType({required this.name});
}
