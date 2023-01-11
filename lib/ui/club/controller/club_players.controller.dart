import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/club.request.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/profile/player/player_profile.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubPlayersController extends BaseController {
  final refreshController = RefreshController();
  final _clubRequest = ClubRequest();
  final _teamRequest = TeamRequest();
  final search = TextEditingController();
  final _players = Resource<List<ClubPlayer>>(data: []).obs;
  final _page = 1.obs;
  final _club = const Club().obs;

  @override
  void onInit() {
    _initialize();
    _fetchPlayers();
    super.onInit();
  }

  _initialize() {
    getUserData();

    if (Get.arguments != null) {
      _club(Club.fromJson(Get.arguments));
    } else {
      _club(userData.value.club);
    }
  }

  refreshData() async {
    try {
      _page(1);
      _players.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchPlayers();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPlayers() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.getClubPlayers(
          clubId: _club.value.id!, page: _page.value, search: search.text);
      _players.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _players.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchPlayers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openPlayerProfile(ClubPlayer? clubPlayer) {
    Get.toNamed(PlayerProfile.routeName, arguments: clubPlayer?.player?.toJson());
  }

  confirmDelete(ClubPlayer? clubPlayer) {
    getDialog(ConfirmationDefaultDialog(
      title: 'Hapus ${clubPlayer?.player?.name ?? '-'} dari klub?',
      onConfirm: () => _deletePlayer(clubPlayer),
    ));
  }

  _deletePlayer(ClubPlayer? clubPlayer) async {
    try {
      EasyLoading.show();
      await _clubRequest.removePlayer(clubPlayerId: clubPlayer!.id);
      _players.update((val) {
        val?.data?.remove(clubPlayer);
      });
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<ClubPlayer>? get players => _players.value.data;
}
