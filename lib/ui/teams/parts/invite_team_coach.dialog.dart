import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/club_coach_position.dart';
import 'package:mobile_pssi/ui/teams/controller/invite_team_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class InviteTeamCoachDialog extends StatefulWidget {
  final InviteTeamCoachController vm;
  final ClubCoach? clubCoach;

  const InviteTeamCoachDialog({Key? key, required this.vm, required this.clubCoach})
      : super(key: key);

  @override
  State<InviteTeamCoachDialog> createState() => _InviteTeamCoachDialogState();
}

class _InviteTeamCoachDialogState extends State<InviteTeamCoachDialog> {
  ClubCoachPosition? selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: VStack([
        'Undang Pelatih Sebagai : '.text.make(),
        DropdownButtonFormField(
            items: widget.clubCoach?.positions
                ?.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: (e.coachPosition?.name ?? '-').text.make(),
                  ),
                )
                .toList(),
            onChanged: (ClubCoachPosition? position) =>
                selectedPosition = position),
        UiSpacer.verticalSpace(),
        'Undang'
            .text
            .white
            .makeCentered()
            .continuousRectangle(
              height: 40,
              backgroundColor: primaryColor,
            )
            .onTap(() => widget.vm.invite(selectedPosition)),
      ]).p12(),
    );
  }
}
