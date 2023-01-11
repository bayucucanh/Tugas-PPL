import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/club.request.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubCoachesController extends BaseController {
  final refreshController = RefreshController();
  final _clubRequest = ClubRequest();
  final _teamRequest = TeamRequest();
  final search = TextEditingController();
  final _coaches = Resource<List<ClubCoach>>(data: []).obs;
  final _page = 1.obs;
  final _club = const Club().obs;

  @override
  void onInit() {
    _initialize();
    _fetchCoaches();
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
      _coaches.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchCoaches();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchCoaches() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.getClubCoaches(
          clubId: _club.value.id!, page: _page.value, search: search.text);
      _coaches.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _coaches.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchCoaches();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openCoachProfile(ClubCoach? clubCoach) {
    Get.toNamed(CoachProfile.routeName,
        arguments: User(id: clubCoach!.employee!.userId).toJson());
  }

  confirmDelete(ClubCoach? clubCoach) {
    getDialog(ConfirmationDefaultDialog(
      title: 'Hapus ${clubCoach?.employee?.name ?? '-'} dari klub?',
      onConfirm: () => _deleteCoach(clubCoach),
    ));
  }

  _deleteCoach(ClubCoach? clubCoach) async {
    try {
      EasyLoading.show();
      await _clubRequest.removeCoach(clubCoachId: clubCoach!.id);
      _coaches.update((val) {
        val?.data?.remove(clubCoach);
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

  List<ClubCoach>? get coaches => _coaches.value.data;
}
