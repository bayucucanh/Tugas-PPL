import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/requests/club.request.dart';
import 'package:mobile_pssi/data/requests/promo.request.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/ui/club/club_coaches.dart';
import 'package:mobile_pssi/ui/club/club_list.dart';
import 'package:mobile_pssi/ui/club/club_players.dart';
import 'package:mobile_pssi/ui/club/club_promo_detail.dart';
import 'package:mobile_pssi/ui/teams/team_screen.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubDetailController extends BaseController {
  final _clubRequest = ClubRequest();
  final _teamRequest = TeamRequest();
  final _promoRequest = PromoRequest();
  final refreshController = RefreshController();
  final teamRefresh = RefreshController();
  final _club = const Club().obs;
  final _teams = Resource<List<Team>>(data: []).obs;
  final _teamPage = 1.obs;
  final _promotions = Resource<List<Promotion>>(data: []).obs;

  @override
  void onInit() {
    getUserData();
    _initialize();
    super.onInit();
  }

  _initialize() {
    _getClubId();
    _fetchClub();
    _refreshTeam();
    if (userData.value.isPlayer) {
      _fetchPromotions();
    }
  }

  refreshData() {
    try {
      getProfile();
      _initialize();
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

  _getClubId() {
    if (userData.value.isPlayer) {
      _club(Club.fromJson(Get.arguments));
    } else if (userData.value.isCoach) {
      _club(userData.value.employee?.clubCoach?.club);
    } else {
      _club(userData.value.club);
    }
  }

  _fetchClub() async {
    try {
      EasyLoading.show();
      _club(await _clubRequest.getDetail(clubId: _club.value.id!));

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchTeam() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.getMyTeams(
          clubId: _club.value.id!, page: _teamPage.value);
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

  _fetchPromotions() async {
    try {
      EasyLoading.show();
      _promotions(
          await _promoRequest.getPromoByClubId(clubId: _club.value.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  goToClubList() {
    Get.toNamed(ClubList.routeName);
  }

  openTeam() {
    Get.toNamed(TeamScreen.routeName);
  }

  openPromotion(Promotion? promotion) {
    Get.toNamed(ClubPromoDetail.routeName, arguments: promotion?.toJson());
  }

  openCoachList() {
    Get.toNamed(ClubCoaches.routeName, arguments: _club.value.toJson());
  }

  openPlayerList() {
    Get.toNamed(ClubPlayers.routeName, arguments: _club.value.toJson());
  }

  Club? get club => _club.value;
  List<Team>? get teams => _teams.value.data;
  List<Promotion>? get promotions => _promotions.value.data;
}
