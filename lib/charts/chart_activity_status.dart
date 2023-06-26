import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymbro/charts/theme/colors.dart';

List<Color> gradientColors = [secondary, primary];
LineChart activityData() {
  return LineChart(LineChartData(
    backgroundColor: Colors.black12,
    gridData: FlGridData(
      show: false,
      drawVerticalLine: true,
    ),
    titlesData: FlTitlesData(
      show: false,
      leftTitles: SideTitles(
        showTitles: false,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 12,
    minY: 0,
    maxY: 22,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 6),
          FlSpot(2, 9),
          FlSpot(4, 7),
          FlSpot(6, 8),
          FlSpot(8, 18),
          FlSpot(10, 11),
          FlSpot(12, 19),
        ],
        isCurved: false,
        colors: gradientColors,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  ));
}
