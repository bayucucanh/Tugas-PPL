import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/ui/teams/new_team.dart';
import 'package:mobile_pssi/ui/teams/team_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyTeamController extends BaseController {
  final refreshController = RefreshController();
  final _teamRequest = TeamRequest();
  final teams = Resource<List<Team>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchTeams();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      teams.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      _fetchTeams();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchTeams() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.getMyTeams(
          clubId: userData.value.club!.id!, page: page.value);
      teams.update((val) {
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
      if (page.value >= teams.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchTeams();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openNewTeam() async {
    var data = await Get.toNamed(NewTeam.routeName);
    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  openDetail(Team? team) {
    Get.toNamed(TeamDetail.routeName, arguments: team?.toJson());
  }
}
