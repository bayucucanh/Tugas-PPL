import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/statistics/controller/detail_statistic.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabMental extends GetView<DetailStatisticController> {
  const TabMental({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack(
        [
          'Skor'.text.semiBold.xl2.make(),
          UiSpacer.verticalSpace(),
          (controller.myPerformance?.scatScore ?? 0)
              .text
              .green400
              .semiBold
              .xl6
              .make(),
          UiSpacer.verticalSpace(),
          (controller.myPerformance?.anxietyDescription ?? '-')
              .text
              .semiBold
              .make(),
        ],
        alignment: MainAxisAlignment.center,
        crossAlignment: CrossAxisAlignment.center,
      ).centered().scrollVertical(),
    );
  }
}
