import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/club.request.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/ui/club/club_coaches.dart';
import 'package:mobile_pssi/ui/club/club_list.dart';
import 'package:mobile_pssi/ui/club/club_players.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachClubDetailController extends BaseController {
  final _clubRequest = ClubRequest();
  final _coachRequest = CoachRequest();
  final refreshController = RefreshController();
  final teamRefresh = RefreshController();
  final _club = const Club().obs;
  final _teams = Resource<List<CoachTeam>>(data: []).obs;
  final _teamPage = 1.obs;

  @override
  void onInit() {
    getUserData();
    _initialize();
    super.onInit();
  }

  _initialize() {
    if (userData.value.employee?.clubCoach != null) {
      _fetchClub();
      _fetchTeam();
    }
  }

  refreshData() {
    try {
      getProfile();
      if (userData.value.employee?.clubCoach != null) {
        _fetchClub();
        _refreshTeam();
      }
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _refreshTeam() {
    _teamPage(1);
    _teams.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
    teamRefresh.resetNoData();
    _fetchTeam();
  }

  loadMoreTeam() {
    try {
      if (_teamPage.value >= _teams.value.meta!.lastPage!) {
        teamRefresh.loadNoData();
      } else {
        _teamPage(_teamPage.value + 1);
        _fetchTeam();
        teamRefresh.loadComplete();
      }
    } catch (_) {
      teamRefresh.loadFailed();
    }
  }

  _fetchClub() async {
    try {
      EasyLoading.show();
      _club(await _clubRequest.getDetail(
          clubId: userData.value.employee!.clubCoach!.club!.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchTeam() async {
    try {
      EasyLoading.show();
      var resp = await _coachRequest.getCoachTeams(page: _teamPage.value);
      _teams.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openCoachList() {
    Get.toNamed(ClubCoaches.routeName, arguments: _club.value.toJson());
  }

  openPlayerList() {
    Get.toNamed(ClubPlayers.routeName, arguments: _club.value.toJson());
  }

  goToClubList() {
    Get.toNamed(ClubList.routeName);
  }

  Club? get club => _club.value;
  List<CoachTeam>? get teams => _teams.value.data;
}
