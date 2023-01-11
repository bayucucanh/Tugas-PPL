import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/scouting/scouting_club_coach_history.dart';
import 'package:mobile_pssi/ui/scouting/scouting_coach_history.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachScoutingController extends BaseController {
  final refreshController = RefreshController();
  final _coachRequest = CoachRequest();
  final positions = Resource<List<CoachPosition>>(data: []).obs;
  final loadingPosition = false.obs;
  final coaches = Resource<List<User>>(data: []).obs;
  final loadingPlayers = false.obs;
  final positionFilter = const CoachPosition().obs;
  final page = 1.obs;
  final search = TextEditingController();

  @override
  void onInit() {
    _fetchCoaches();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      coaches.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchCoaches();
      refreshController.refreshCompleted();
      Get.focusScope?.unfocus();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (page.value >= coaches.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchCoaches();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  _fetchCoaches() async {
    try {
      loadingPlayers(true);
      var resp = await _coachRequest.getCoachScout(
        page: page.value,
        search: search.text,
      );
      coaches.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      loadingPlayers(false);
    } catch (e) {
      loadingPlayers(false);
    }
  }

  changeFilter(CoachPosition? position) {
    if (positionFilter.value.id == position?.id) {
      positionFilter(const CoachPosition());
    } else {
      positionFilter(position);
    }
    refreshController.requestRefresh();
  }

  getDetail(User? coach) {
    Get.toNamed(CoachProfile.routeName, arguments: coach?.toJson());
  }

  getHistory() {
    Get.toNamed(ScoutingCoachHistory.routeName);
  }

  getClubCoachHistory() {
    Get.toNamed(ScoutingClubCoachHistory.routeName);
  }
}
