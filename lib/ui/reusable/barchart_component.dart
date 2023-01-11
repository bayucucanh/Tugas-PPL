import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartComponent extends StatelessWidget {
  final bool showGrid;
  final List<BarChartGroupData> groupData;

  const BarChartComponent({
    Key? key,
    this.showGrid = false,
    required this.groupData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: showGrid,
        ),
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: groupData,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
