import 'dart:math';

import 'package:flutter/material.dart';
import 'package:screen_me/api/dash.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

SfCircularChart buildChart(DashInfo? dashInfo) {
  final mindfulMin = dashInfo?.fitnessInfo.mindful ?? 0.0;
  final mindful100 = max(mindfulMin, 0.5) / 5 * 100;
  final exec100 = max(dashInfo?.fitnessInfo.exercise ?? 3, 3) / 30 * 100;
  final workout100 = max((dashInfo?.fitnessInfo.active ?? 50), 50) /
      (dashInfo?.fitnessInfo.globalActive ?? 500.0) *
      100;
  return SfCircularChart(
      legend: const Legend(
          isVisible: false,
          iconHeight: 20,
          iconWidth: 20,
          overflowMode: LegendItemOverflowMode.wrap),
      series: <RadialBarSeries<ChartSampleData, String>>[
        RadialBarSeries<ChartSampleData, String>(
            animationDuration: 0,
            maximumValue: 100,
            radius: '100%',
            gap: '2%',
            innerRadius: '30%',
            dataSource: <ChartSampleData>[
              ChartSampleData(
                  x: 'Mindful',
                  y: mindful100,
                  text: '呼吸',
                  pointColor: const Color.fromRGBO(0, 201, 230, 1.0)),
              ChartSampleData(
                  x: 'Exercise',
                  y: exec100,
                  text: '锻炼',
                  pointColor: const Color.fromRGBO(63, 224, 0, 1.0)),
              ChartSampleData(
                  x: 'Active',
                  y: workout100,
                  text: '活动',
                  pointColor: const Color.fromRGBO(226, 1, 26, 1.0)),
            ],
            cornerStyle: CornerStyle.bothCurve,
            xValueMapper: (ChartSampleData data, _) => data.x as String,
            yValueMapper: (ChartSampleData data, _) => data.y,
            pointColorMapper: (ChartSampleData data, _) => data.pointColor,
            trackColor: Colors.white,
            trackBorderColor: Colors.black,
            trackBorderWidth: 0,
            trackOpacity: 0.15,
            dataLabelMapper: (ChartSampleData data, _) => data.text,
            dataLabelSettings: const DataLabelSettings(isVisible: true))
      ]);
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
