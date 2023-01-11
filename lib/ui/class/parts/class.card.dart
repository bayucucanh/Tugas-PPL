import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassCard extends StatelessWidget {
  final Class data;
  final Function()? onTap;
  const ClassCard({Key? key, required this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: HStack(
        [
          ImageCustom(
            url: data.thumbnails!.origin!,
            blurhash: data.blurhash,
          ).wh(200, 120).cornerRadius(10),
          UiSpacer.horizontalSpace(space: 10),
          VStack(
            [
              (data.name ?? '-').text.ellipsis.maxLines(2).bold.make(),
              UiSpacer.verticalSpace(space: 10),
              HStack([
                const Icon(
                  Icons.face_rounded,
                  size: 14,
                  color: creditColor,
                ),
                UiSpacer.horizontalSpace(space: 5),
                (data.createdBy ?? '-')
                    .text
                    .sm
                    .color(creditColor)
                    .ellipsis
                    .make()
                    .expand(),
              ]),
              UiSpacer.verticalSpace(space: 8),
              data.totalRiview! <= 0
                  ? 'Belum ada ulasan'.text.sm.gray500.make()
                  : VStack([
                      HStack([
                        '${data.rating}'.text.color(primaryColor).sm.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        RatingBar.builder(
                          initialRating:
                              double.tryParse(data.rating.toString()) ?? 0,
                          itemCount: 5,
                          minRating: 0,
                          maxRating: 5,
                          itemSize: 20,
                          allowHalfRating: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: starColor,
                          ),
                          glow: true,
                          ignoreGestures: true,
                          onRatingUpdate: (value) {},
                        ),
                      ]),
                      UiSpacer.verticalSpace(space: 5),
                      HStack([
                        const Icon(
                          Icons.rate_review_rounded,
                          size: 14,
                          color: primaryColor,
                        ),
                        UiSpacer.horizontalSpace(space: 5),
                        '${data.totalRiview ?? 0}'.text.sm.make(),
                      ]),
                    ]),
              UiSpacer.verticalSpace(space: 10),
              HStack([
                (data.isPremium ?? '-')
                    .text
                    .white
                    .make()
                    .p4()
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
                      .p4()
                      .box
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .color(trendingColor)
                      .roundedSM
                      .make(),
              ]),
              UiSpacer.divider(height: 15),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ).expand(),
        ],
        crossAlignment: CrossAxisAlignment.start,
      ).px4().marginOnly(top: 10),
    );
  }
}
