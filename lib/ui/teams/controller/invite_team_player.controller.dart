import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/club_player_position.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/ui/teams/parts/invite_team_player.dialog.dart';
import 'package:mobile_pssi/ui/teams/player_club_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InviteTeamPlayerController extends BaseController {
  final _teamRequest = TeamRequest();
  final refreshController = RefreshController();
  final search = TextEditingController();
  final clubPlayers = Resource<List<ClubPlayer>>(data: []).obs;
  final team = const Team().obs;
  final page = 1.obs;

  InviteTeamPlayerController() {
    team(Team.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _fetchClubPlayers();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      clubPlayers.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      _fetchClubPlayers();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchClubPlayers() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.getClubPlayers(
          clubId: userData.value.club!.id!,
          page: page.value,
          search: search.text);
      clubPlayers.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (page.value >= clubPlayers.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchClubPlayers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(Player? player) {
    Get.toNamed(PlayerClubDetail.routeName, arguments: player?.toJson());
  }

  selectPlayer(ClubPlayer? clubPlayer) async {
    try {
      ClubPlayerPosition? selectedPosition = await Get.dialog(
        InviteTeamPlayerDialog(
          vm: this,
          clubPlayer: clubPlayer,
        ),
      );

      if (selectedPosition != null) {
        EasyLoading.show();
        await _teamRequest.invitePlayer(
          clubPlayerId: clubPlayer?.id,
          position: selectedPosition.playerPosition,
          teamId: team.value.id,
        );
        EasyLoading.dismiss();
        clubPlayers.update((val) {
          val?.data?.remove(clubPlayer);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  invite(ClubPlayerPosition? position) async {
    Get.back(result: position);
  }
}
