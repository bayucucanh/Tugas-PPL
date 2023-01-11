import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/ui/offering/controller/offer_list_team_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferingTeamPlayerDetailDialog extends StatelessWidget {
  final OfferListTeamPlayerController vm;
  final PlayerTeam? playerTeam;

  const OfferingTeamPlayerDetailDialog(
      {Key? key, required this.vm, required this.playerTeam})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: VStack([
        'Konfirmasi Penawaran Gabung Tim'.text.semiBold.make(),
        UiSpacer.verticalSpace(),
        'Anda diundang ke dalam sebuah tim ${playerTeam?.team?.name ?? '-'} untuk menjadi ${playerTeam?.playerPosition?.name ?? '-'} ?'
            .text
            .make(),
        UiSpacer.verticalSpace(),
        HStack(
          [
            'Tolak'
                .text
                .color(primaryColor)
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  width: 100,
                  backgroundColor: Colors.white,
                )
                .onTap(() => vm.changeStatus(playerTeam, 0)),
            'Terima'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  width: 100,
                  backgroundColor: primaryColor,
                )
                .onTap(() => vm.changeStatus(playerTeam, 1)),
          ],
          alignment: MainAxisAlignment.spaceEvenly,
          crossAlignment: CrossAxisAlignment.center,
          axisSize: MainAxisSize.max,
        ),
      ]).p12(),
    );
  }
}
