import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/statistics/controller/detail_statistic.controller.dart';
import 'package:mobile_pssi/ui/statistics/parts/empty_radar.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabPhysique extends GetView<DetailStatisticController> {
  const TabPhysique({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        VStack([
          HStack([
            'Fisik'.text.bold.make().expand(),
            // const Icon(Icons.more_vert_rounded),
          ]),
          UiSpacer.verticalSpace(),
          controller.physiques == null || controller.physiques!.isEmpty
              ? const EmptyRadar()
              : RadarChart(
                  ticks: const [20, 40, 60, 80, 100],
                  features: controller.physiques!
                      .map((e) => (e.performanceItem?.name ?? '-'))
                      .toList(),
                  data: [
                    controller.physiques!
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
