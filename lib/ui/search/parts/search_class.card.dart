import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/utils.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchClassCard extends StatelessWidget {
  final Class classData;
  const SearchClassCard({Key? key, required this.classData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        ImageCustom(
          url: classData.thumbnails!.origin!,
          blurhash: classData.blurhash,
        ).wh(200, 120).cornerRadius(20),
        UiSpacer.horizontalSpace(space: 10),
        VStack(
          [
            (classData.name ?? '-').text.ellipsis.maxLines(2).bold.make(),
            UiSpacer.verticalSpace(space: 10),
            HStack([
              const Icon(
                Icons.face_rounded,
                size: 14,
                color: creditColor,
              ),
              UiSpacer.horizontalSpace(space: 5),
              (classData.createdBy ?? '-')
                  .text
                  .sm
                  .color(creditColor)
                  .ellipsis
                  .make()
                  .expand(),
            ]),
            UiSpacer.verticalSpace(space: 8),
            HStack([
              (classData.rating == null
                      ? 'Belum ada rating'
                      : classData.rating.toString())
                  .text
                  .color(primaryColor)
                  .sm
                  .make(),
              UiSpacer.horizontalSpace(space: 5),
              RatingBar.builder(
                initialRating: classData.rating ?? 0,
                itemCount: 5,
                minRating: 0,
                maxRating: 5,
                itemSize: 20,
                ignoreGestures: true,
                allowHalfRating: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: starColor,
                ),
                glow: true,
                onRatingUpdate: (value) {},
              ),
              '(${classData.totalRiview})'.text.sm.make()
            ]),
            UiSpacer.verticalSpace(space: 10),
            HStack([
              (classData.isPremium ?? '-')
                  .text
                  .white
                  .make()
                  .p4()
                  .box
                  .margin(const EdgeInsets.symmetric(horizontal: 4))
                  .color(classData.isPremiumContent ? primaryColor : freeColor)
                  .roundedSM
                  .make(),
              classData.isTrending == null
                  ? UiSpacer.emptySpace()
                  : 'Trending'
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
    ).px4().marginOnly(top: 10);
  }
}
