import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/statistics/controller/detail_statistic.controller.dart';
import 'package:mobile_pssi/ui/statistics/parts/empty_radar.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabTechnique extends GetView<DetailStatisticController> {
  const TabTechnique({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Teknik'.text.bold.make().expand(),
        // const Icon(Icons.more_vert_rounded),
      ]),
      UiSpacer.verticalSpace(),
      controller.techniques == null || controller.techniques!.isEmpty
          ? const EmptyRadar()
          : RadarChart(
              ticks: const [20, 40, 60, 80, 100],
              features: controller.techniques!
                  .map((e) => (e.performanceItem?.name ?? '-'))
                  .toList(),
              data: [
                controller.techniques!.map((e) => (e.actualScore ?? 0)).toList()
              ],
              featuresTextStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              graphColors: const [primaryColor],
              outlineColor: Colors.grey,
            ).box.make().h(200),
    ]).p12().card.make();
  }
}
