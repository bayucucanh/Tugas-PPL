import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyRadar extends StatelessWidget {
  final double height;
  const EmptyRadar({Key? key, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RadarChart(
      ticks: [20, 40, 60, 80, 100],
      features: [],
      data: [],
      featuresTextStyle: TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      graphColors: [primaryColor],
      outlineColor: Colors.grey,
    ).box.make().h(height);
  }
}
