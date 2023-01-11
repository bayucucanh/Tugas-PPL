import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/data/model/formation.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:velocity_x/velocity_x.dart';

class FieldPosition extends StatelessWidget {
  final Player? player;
  final bool? isMobileSize;
  const FieldPosition({Key? key, this.player, this.isMobileSize = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZStack([
      SvgPicture.asset(
              'assets/images/football-field-soccer-field-svgrepo-com.svg')
          .h(isMobileSize == true ? 350 : 550)
          .wFull(context),
      'Posisi'
          .text
          .xl
          .semiBold
          .makeCentered()
          .positioned(top: 0, right: 0, left: 0),
      ZStack(Formation.fourThreeThree(player, isMobileSize!))
          .h(isMobileSize == true ? 350 : 550),
    ]);
  }
}
