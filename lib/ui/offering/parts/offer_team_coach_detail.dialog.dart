import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/ui/offering/controller/offer_list_team_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferingTeamCoachDetailDialog extends StatelessWidget {
  final OfferListTeamCoachController vm;
  final CoachTeam? coachTeam;

  const OfferingTeamCoachDetailDialog(
      {Key? key, required this.vm, required this.coachTeam})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: VStack([
        'Konfirmasi Penawaran Gabung Tim'.text.semiBold.make(),
        UiSpacer.verticalSpace(),
        'Anda diundang ke dalam sebuah tim ${coachTeam?.team?.name ?? '-'} untuk menjadi ${coachTeam?.coachPosition?.name ?? '-'} ?'
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
                .onTap(() => vm.changeStatus(coachTeam, 0)),
            'Terima'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  width: 100,
                  backgroundColor: primaryColor,
                )
                .onTap(() => vm.changeStatus(coachTeam, 1)),
          ],
          alignment: MainAxisAlignment.spaceEvenly,
          crossAlignment: CrossAxisAlignment.center,
          axisSize: MainAxisSize.max,
        ),
      ]).p12(),
    );
  }
}
