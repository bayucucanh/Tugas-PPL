import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassCard extends StatelessWidget {
  final Class data;
  final Function() onTap;
  const ClassCard({Key? key, required this.data, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        ZStack([
          ImageCustom(
            url: data.thumbnails!.origin!,
            blurhash: data.blurhash,
          ).wh(200, 120).cornerRadius(10),
          HStack(
            [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: starColor,
              ),
              UiSpacer.horizontalSpace(space: 4),
              data.totalRiview == 0
                  ? 'Belum ada ulasan'.text.sm.make()
                  : '${data.rating}'.text.sm.make(),
            ],
            alignment: MainAxisAlignment.spaceEvenly,
            crossAlignment: CrossAxisAlignment.center,
          ).px4().card.make(),
        ]),
        UiSpacer.verticalSpace(space: 10),
        (data.name ?? '-').text.ellipsis.maxLines(2).bold.make(),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          const Icon(
            Icons.face_rounded,
            size: 14,
            color: creditColor,
          ),
          UiSpacer.horizontalSpace(space: 5),
          (data.createdBy ?? '-').text.sm.color(creditColor).make(),
        ]),
        UiSpacer.verticalSpace(space: 8),
        HStack([
          (data.isPremium ?? '-')
              .text
              .white
              .make()
              .p8()
              .box
              .margin(const EdgeInsets.symmetric(horizontal: 4))
              .color(data.isPremiumContent ? primaryColor : freeColor)
              .roundedSM
              .make(),
          if (data.isTrending != null)
            'Trending'
                .text
                .white
                .make()
                .p8()
                .box
                .margin(const EdgeInsets.symmetric(horizontal: 4))
                .color(trendingColor)
                .roundedSM
                .make(),
        ])
      ],
    ).marginOnly(right: 20).onTap(onTap);
  }
}
