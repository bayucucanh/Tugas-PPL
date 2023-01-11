import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/statistics/controller/detail_statistic.controller.dart';
import 'package:mobile_pssi/ui/statistics/parts/empty_radar.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabTactic extends GetView<DetailStatisticController> {
  const TabTactic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        VStack([
          HStack([
            'Taktik : Attacking'.text.bold.make().expand(),
            // const Icon(Icons.more_vert_rounded),
          ]),
          UiSpacer.verticalSpace(),
          controller.attackTactic == null || controller.attackTactic!.isEmpty
              ? const EmptyRadar()
              : RadarChart(
                  ticks: const [20, 40, 60, 80, 100],
                  features: controller.attackTactic!
                      .map((e) => (e.performanceItem?.name ?? '-'))
                      .toList(),
                  data: [
                    controller.attackTactic!
                        .map((e) => (e.actualScore ?? 0))
                        .toList()
                  ],
                  featuresTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  graphColors: const [primaryColor],
                  outlineColor: Colors.grey,
                ).box.make().h(200),
        ]).p12().card.make(),
        VStack([
          HStack([
            'Taktik : Defending'.text.bold.make().expand(),
            // const Icon(Icons.more_vert_rounded),
          ]),
          UiSpacer.verticalSpace(),
          controller.defendTactic == null || controller.defendTactic!.isEmpty
              ? const EmptyRadar()
              : RadarChart(
                  ticks: const [20, 40, 60, 80, 100],
                  features: controller.defendTactic!
                      .map((e) => (e.performanceItem?.name ?? '-'))
                      .toList(),
                  data: [
                    controller.defendTactic!
                        .map((e) => (e.actualScore ?? 0))
                        .toList()
                  ],
                  featuresTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  graphColors: const [primaryColor],
                  outlineColor: Colors.grey,
                ).box.make().h(200),
        ]).p12().card.make(),
      ]).scrollVertical(),
    );
  }
}
