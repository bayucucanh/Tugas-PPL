import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CurrentWatchList extends GetView<PlayerController> {
  const CurrentWatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Lanjutkan Menonton'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(() => controller.allWatchesVideo())
      ]).px12(),
      Obx(() => controller.latestWatches.value.data!.isEmpty
          ? 'Belum ada video ditonton'.text.makeCentered()
          : ListView.builder(
              itemCount: controller.latestWatches.value.data?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final latestWatch = controller.latestWatches.value.data?[index];
                return VStack([
                  ZStack([
                    ImageCustom(
                      url: latestWatch!.thumbnails!.origin!,
                      blurhash: latestWatch.blurhash,
                    ).wh(200, 120).cornerRadius(10),
                  ]),
                  UiSpacer.verticalSpace(space: 10),
                  (latestWatch.className ?? '-')
                      .text
                      .bold
                      .maxLines(2)
                      .ellipsis
                      .make()
                      .w(190),
                  UiSpacer.verticalSpace(space: 10),
                  HStack([
                    const Icon(
                      Icons.face_rounded,
                      size: 14,
                      color: creditColor,
                    ),
                    UiSpacer.horizontalSpace(space: 5),
                    (latestWatch.creatorName ?? '-')
                        .text
                        .sm
                        .color(creditColor)
                        .make(),
                  ])
                ]).p12().onTap(() => controller.openClass(latestWatch));
              },
              scrollDirection: Axis.horizontal,
            ).h(220)),
    ]).py(15);
  }
}
