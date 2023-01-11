import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class OfficialCard extends StatelessWidget {
  const OfficialCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        HStack([
          'Agus Subagja'.text.semiBold.sm.make(),
          UiSpacer.horizontalSpace(space: 10),
          const Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: officialCheckColor,
          ),
        ]).expand(),
        '10:00'.text.sm.gray500.make()
      ]),
      UiSpacer.verticalSpace(space: 5),
      'Asep, kamu harus segera melakukan latihan dribble untuk meningkatkan skill dribble kamu!'
          .text
          .sm
          .make(),
    ])
        .p12()
        .box
        .gray100
        .margin(const EdgeInsets.only(right: 30))
        .roundedSM
        .make()
        .py4();
  }
}
