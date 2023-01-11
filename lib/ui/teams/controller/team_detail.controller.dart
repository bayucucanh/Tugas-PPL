import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/teams/coach_club_invite.dart';
import 'package:mobile_pssi/ui/teams/edit_team.dart';
import 'package:mobile_pssi/ui/teams/player_club_detail.dart';
import 'package:mobile_pssi/ui/teams/player_club_invite.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeamDetailController extends BaseController {
  final refreshController = RefreshController();
  final _teamRequest = TeamRequest();
  final team = const Team(
    coaches: [],
    players: [],
  ).obs;

  TeamDetailController() {
    team(Team.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchDetail();
    super.onInit();
  }

  refreshData() {
    try {
      _fetchDetail();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();
      team(await _teamRequest.getDetailTeam(teamId: team.value.id!));
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  openPlayerInvite() {
    Get.toNamed(PlayerClubInvite.routeName, arguments: team.value.toJson());
  }

  openCoachInvite() {
    Get.toNamed(CoachClubInvite.routeName, arguments: team.value.toJson());
  }

  openDetailPlayer(Player? player) {
    Get.toNamed(PlayerClubDetail.routeName, arguments: player?.toJson());
  }

  openDetailCoach(Employee? employee) {
    Get.toNamed(CoachProfile.routeName,
        arguments: User(id: employee?.userId, employee: employee).toJson());
  }

  cancelInvitePlayer(PlayerTeam? playerTeam) async {
    try {
      EasyLoading.show();
      await _teamRequest.cancelPlayer(playerTeamId: playerTeam!.id);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      team.update((val) {
        val?.players?.remove(playerTeam);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  cancelCoachDialog(CoachTeam? coachTeam) {
    getDialog(ConfirmationDefaultDialog(
      title: 'Keluarkan Pelatih',
      content:
          'Apakah anda yakin ingin mengeluarkan pelatih ${coachTeam?.coach?.name ?? '-'}?',
      onConfirm: () => cancelInviteCoach(coachTeam),
    ));
  }

  cancelPlayerDialog(PlayerTeam? playerTeam) {
    getDialog(ConfirmationDefaultDialog(
      title: 'Keluarkan Pemain',
      content:
          'Apakah anda yakin ingin mengeluarkan pemain ${playerTeam?.clubPlayer?.player?.name ?? '-'}?',
      onConfirm: () => cancelInvitePlayer(playerTeam),
    ));
  }

  cancelInviteCoach(CoachTeam? coachTeam) async {
    try {
      EasyLoading.show();
      await _teamRequest.cancelCoach(coachTeamId: coachTeam!.id);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      team.update((val) {
        val?.coaches?.remove(coachTeam);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openEditTeam() {
    Get.toNamed(EditTeam.routeName, arguments: team.value.toJson());
  }
}
