import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/scouting/controller/scouting_player_detail.controller.dart';
import 'package:mobile_pssi/ui/statistics/parts/empty_radar.dart';
import 'package:velocity_x/velocity_x.dart';

class ChartCategory extends GetView<ScoutingPlayerDetailController> {
  final int categoryId;
  const ChartCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.player?.performanceTestVerification
                      ?.getPerformanceVerificationByCategoryId(categoryId) ==
                  null ||
              controller.player!.performanceTestVerification!
                  .getPerformanceVerificationByCategoryId(categoryId)!
                  .isEmpty
          ? const EmptyRadar()
          : RadarChart(
              ticks: const [20, 40, 60, 80, 100],
              features: controller.player!.performanceTestVerification!
                  .getPerformanceVerificationByCategoryId(categoryId)!
                  .map((e) => (e.performanceItem?.name ?? '-'))
                  .toList(),
              data: [
                controller.player!.performanceTestVerification!
                    .getPerformanceVerificationByCategoryId(categoryId)!
                    .map((e) => e.actualScore ?? 0)
                    .toList()
              ],
              featuresTextStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              graphColors: const [primaryColor],
              outlineColor: Colors.grey,
            ).box.make().h(200),
    );
  }
}
