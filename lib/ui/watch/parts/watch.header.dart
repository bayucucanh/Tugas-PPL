import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/extensions/numeral.extension.dart';
import 'package:mobile_pssi/ui/watch/controller/watch.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class WatchHeader extends GetView<WatchController> {
  const WatchHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        HStack([
          VStack([
            (controller.classDetail.name ?? '-').text.xl2.semiBold.make(),
            if (controller.currentVideo != null)
              '#${(controller.currentWatch.value + 1)} - ${controller.currentVideo?.name ?? ''}'
                  .text
                  .xl
                  .semiBold
                  .make(),
          ]).expand(),
          if (controller.currentVideo != null)
            Checkbox(
              value: controller.currentVideo?.checkedVideo ?? false,
              onChanged: (value) =>
                  controller.checkVideo(value, controller.currentVideo),
              activeColor: primaryColor,
              splashRadius: 10,
            )
        ]),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          const Icon(
            Icons.face_rounded,
            size: 14,
          ),
          UiSpacer.horizontalSpace(space: 5),
          (controller.classDetail.createdBy ?? '-').text.sm.gray500.make(),
        ]),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          '${controller.currentVideo?.totalView!.numeral() ?? 0} views'
              .text
              .sm
              .gray500
              .make(),
        ])
      ]),
    );
  }
}
