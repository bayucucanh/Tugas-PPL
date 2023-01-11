import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/club_coach_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/teams/parts/invite_team_coach.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InviteTeamCoachController extends BaseController {
  final _teamRequest = TeamRequest();
  final refreshController = RefreshController();
  final search = TextEditingController();
  final clubCoaches = Resource<List<ClubCoach>>(data: []).obs;
  final team = const Team().obs;
  final page = 1.obs;

  InviteTeamCoachController() {
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
      clubCoaches.update((val) {
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
      var resp = await _teamRequest.getClubCoaches(
        clubId: userData.value.club!.id!,
          page: page.value, search: search.text);
      clubCoaches.update((val) {
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
      if (page.value >= clubCoaches.value.meta!.lastPage!) {
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

  openDetail(Employee? employee) {
    Get.toNamed(CoachProfile.routeName,
        arguments: User(id: employee?.userId, employee: employee).toJson());
  }

  selectCoach(ClubCoach? clubCoach) async {
    try {
      ClubCoachPosition? selectedPosition = await Get.dialog(
        InviteTeamCoachDialog(
          vm: this,
          clubCoach: clubCoach,
        ),
      );

      if (selectedPosition != null) {
        EasyLoading.show();
        await _teamRequest.inviteCoach(
          employeeId: clubCoach?.employee?.id,
          position: selectedPosition.coachPosition,
          teamId: team.value.id,
        );
        EasyLoading.dismiss();
        clubCoaches.update((val) {
          val?.data?.remove(clubCoach);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  invite(ClubCoachPosition? position) async {
    Get.back(result: position);
  }
}
