import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club_player_offering.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubPlayerScoutingHistoryController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final _offerings = Resource<List<ClubPlayerOffering>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchOfferingPlayers();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      _offerings.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchOfferingPlayers();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOfferingPlayers() async {
    try {
      EasyLoading.show();
      var resp =
          await _offeringRequest.historyOfferingClubPlayers(page: page.value);
      _offerings.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (page.value >= _offerings.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchOfferingPlayers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetailPlayer(Player? player) {
    Get.toNamed(ScoutingPlayerDetail.routeName, arguments: player?.toJson());
  }

  cancelOfferingPlayer(ClubPlayerOffering? offering) async {
    try {
      EasyLoading.show();
      await _offeringRequest.cancelOfferingClubPlayer(offerId: offering!.id);
      _offerings.update((val) {
        val?.data?.remove(offering);
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  List<ClubPlayerOffering>? get offerings => _offerings.value.data;
}
