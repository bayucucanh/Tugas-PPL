import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PremiumButton extends GetView<PlayerController> {
  const PremiumButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        Image.asset(ticketImage),
        UiSpacer.horizontalSpace(),
        VStack(
          [
            'Kelas Premium'.text.bold.make(),
            UiSpacer.verticalSpace(space: 10),
            'Bergabung di kelas premium bersama dengan 1 juta pengguna, Keuntungan kelas premium Unlimited Watch Videos & Konsultasi Pelatih'
                .text
                .sm
                .light
                .make()
                .expand(),
            UiSpacer.verticalSpace(space: 10),
            'Gabung'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  backgroundColor: primaryColor,
                )
                .onTap(controller.openPremiumJoin)
          ],
          alignment: MainAxisAlignment.start,
        ).expand()
      ],
      alignment: MainAxisAlignment.start,
      crossAlignment: CrossAxisAlignment.start,
    ).h(145).p12().card.make().wFull(context).p12();
  }
}
