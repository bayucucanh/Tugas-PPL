import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/my_class.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class MyClassProgressCard extends StatelessWidget {
  final MyClass myClass;
  final Function()? onRate;
  const MyClassProgressCard({
    Key? key,
    required this.myClass,
    this.onRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack([
          ImageCustom(
            url: myClass.thumbnails!.origin!,
            blurhash: myClass.blurhash,
          ).wh(200, 120).cornerRadius(10),
          UiSpacer.horizontalSpace(),
          VStack([
            (myClass.className ?? '-')
                .text
                .semiBold
                .ellipsis
                .maxLines(2)
                .make(),
            UiSpacer.verticalSpace(space: 5),
            HStack([
              const Icon(
                Icons.face_rounded,
                size: 14,
                color: Colors.grey,
              ),
              UiSpacer.horizontalSpace(space: 5),
              (myClass.createdBy ?? '-')
                  .text
                  .gray500
                  .sm
                  .ellipsis
                  .make()
                  .expand(),
            ]),
            UiSpacer.verticalSpace(space: 10),
            (myClass.totalVideoWatched ?? '-').text.sm.make(),
            UiSpacer.verticalSpace(space: 10),
            HStack([
              (myClass.isPremium ?? '-')
                  .text
                  .sm
                  .white
                  .make()
                  .p4()
                  .box
                  .margin(const EdgeInsets.symmetric(horizontal: 4))
                  .color(
                      myClass.isPremium == 'Gratis' ? freeColor : primaryColor)
                  .roundedSM
                  .make(),
              (myClass.status ?? '-')
                  .text
                  .sm
                  .white
                  .make()
                  .p4()
                  .box
                  .margin(const EdgeInsets.symmetric(horizontal: 4))
                  .color(myClass.status == 'Belum Selesai'
                      ? notDoneColor
                      : primaryColor)
                  .roundedSM
                  .make(),
            ]).scrollHorizontal(),
          ]).expand()
        ]),
        UiSpacer.verticalSpace(space: 10),
        HStack([
          '${myClass.progressToPercent.toDoubleStringAsFixed(digit: 2)}%'
              .text
              .xs
              .color(primaryColor)
              .semiBold
              .make()
              .expand(),
          '100%'.text.xs.gray500.make(),
        ]),
        LinearProgressIndicator(
          value: double.tryParse(myClass.progress.toString()),
          backgroundColor: primaryColor.withOpacity(0.5),
          color: primaryColor,
          minHeight: 10,
        ).cornerRadius(20),
        if (myClass.progress == 1 && onRate != null)
          VStack([
            UiSpacer.divider(height: 20),
            (myClass.rating?.rating != null ? 'Lihat Review' : 'Review Kelas')
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 30,
                  width: 120,
                  backgroundColor: primaryColor,
                )
                .onInkTap(myClass.deletedAt == null ? onRate : null),
          ])
      ],
    ).p8().card.make();
  }
}
