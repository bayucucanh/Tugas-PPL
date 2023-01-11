import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/club/controller/coach_club_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyClub extends GetView<CoachClubDetailController> {
  const EmptyClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      SvgPicture.asset('assets/images/ball-soccer-svgrepo-com.svg').h(140),
      UiSpacer.verticalSpace(),
      'Belum tergabung ke dalam klub apapun.'.text.makeCentered(),
      UiSpacer.verticalSpace(),
      HStack(
        [
          'Lihat Tawaran Klub'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                height: 40,
                width: 140,
                backgroundColor: primaryColor,
              )
              .onTap(controller.openOffersClub),
          'Cari Klub'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                height: 40,
                width: 140,
                backgroundColor: primaryColor,
              )
              .onInkTap(controller.goToClubList),
        ],
        axisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.spaceEvenly,
      ),
    ]);
  }
}
