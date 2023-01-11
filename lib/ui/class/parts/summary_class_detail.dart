import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/class/controller/class_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SummaryClassDetail extends GetView<ClassDetailController> {
  const SummaryClassDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        HStack(
          [
            Hero(
              tag: 'class_${controller.classData.value.id}',
              child: ImageCustom(
                url: controller.classData.value.thumbnails!.origin!,
                blurhash: controller.classData.value.blurhash,
              ).cornerRadius(20).wh(150, 120),
            ),
            UiSpacer.horizontalSpace(space: 5),
            VStack([
              HStack([
                VStack([
                  'Total Pemain'.text.semiBold.make(),
                  HStack([
                    const Icon(
                      Icons.supervised_user_circle_rounded,
                      color: primaryColor,
                    ),
                    (controller.classData.value.totalPlayer ?? 0).text.make()
                  ])
                ]),
                UiSpacer.horizontalSpace(),
                VStack([
                  'Total Video'.text.semiBold.make(),
                  HStack([
                    const Icon(
                      Icons.videocam_rounded,
                      color: primaryColor,
                    ),
                    (controller.classData.value.totalVideo ?? 0).text.make()
                  ]),
                ]),
              ]),
              UiSpacer.verticalSpace(space: 10),
              HStack([
                VStack([
                  'Total Review'.text.semiBold.make(),
                  HStack([
                    const Icon(
                      Icons.rate_review_rounded,
                      color: primaryColor,
                    ),
                    (controller.classData.value.totalRiview ?? 0).text.make()
                  ]),
                ]),
                UiSpacer.horizontalSpace(),
                VStack([
                  'Dibuat Oleh'.text.semiBold.make(),
                  HStack([
                    const Icon(
                      Icons.face_rounded,
                      color: primaryColor,
                    ),
                    UiSpacer.horizontalSpace(space: 10),
                    (controller.classData.value.createdBy ?? '-')
                        .text
                        .sm
                        .maxLines(2)
                        .ellipsis
                        .make()
                        .expand()
                  ]),
                ]).expand(),
              ]),
            ]).expand(),
          ],
          axisSize: MainAxisSize.max,
        ),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          VStack([
            'Rating'.text.semiBold.make(),
            HStack([
              '${controller.classData.value.rating}'
                  .text
                  .color(primaryColor)
                  .sm
                  .make(),
              UiSpacer.horizontalSpace(space: 5),
              RatingBar.builder(
                initialRating: controller.classData.value.rating == null
                    ? 0
                    : double.parse(
                        controller.classData.value.rating.toString()),
                itemCount: 5,
                minRating: 0,
                maxRating: 5,
                itemSize: 20,
                allowHalfRating: true,
                ignoreGestures: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: starColor,
                ),
                glow: false,
                onRatingUpdate: (value) {},
              ),
              '(${controller.classData.value.totalRiview ?? 0})'.text.sm.make()
            ]),
          ]),
          UiSpacer.horizontalSpace(space: 10),
          VStack([
            'Tipe Kelas'.text.semiBold.make(),
            UiSpacer.verticalSpace(space: 5),
            (controller.classData.value.isPremium ?? '-')
                .text
                .sm
                .white
                .make()
                .p4()
                .box
                .margin(const EdgeInsets.symmetric(horizontal: 4))
                .color(controller.classData.value.isPremiumContent
                    ? primaryColor
                    : freeColor)
                .roundedSM
                .make(),
          ]),
          if (controller.classData.value.isTrending != null)
            'Trending'
                .text
                .white
                .make()
                .p4()
                .box
                .margin(const EdgeInsets.symmetric(horizontal: 4))
                .color(trendingColor)
                .roundedSM
                .make(),
        ]),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          'Daftar Video'.text.semiBold.xl.make().expand(),
          if (!controller.userData.value.hasRole('administrator'))
            'Tambah Video Baru'
                .text
                .white
                .center
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  width: 120,
                  backgroundColor: primaryColor,
                )
                .onInkTap(controller.openAddVideoForm),
        ]),
      ]),
    );
  }
}
