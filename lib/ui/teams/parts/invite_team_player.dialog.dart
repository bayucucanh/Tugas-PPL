import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/club_player_position.dart';
import 'package:mobile_pssi/ui/teams/controller/invite_team_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class InviteTeamPlayerDialog extends StatefulWidget {
  final InviteTeamPlayerController vm;
  final ClubPlayer? clubPlayer;

  const InviteTeamPlayerDialog({Key? key, required this.vm, required this.clubPlayer})
      : super(key: key);

  @override
  State<InviteTeamPlayerDialog> createState() => _InviteTeamPlayerDialogState();
}

class _InviteTeamPlayerDialogState extends State<InviteTeamPlayerDialog> {
  ClubPlayerPosition? selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: VStack([
        'Undang Pemain Sebagai : '.text.make(),
        DropdownButtonFormField(
            items: widget.clubPlayer?.positions
                ?.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: (e.playerPosition?.name ?? '-').text.make(),
                  ),
                )
                .toList(),
            onChanged: (ClubPlayerPosition? position) =>
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
