import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/player_offering.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlayerScoutingHistoryController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final offerings = Resource<List<PlayerOffering>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchOfferingPlayers();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      offerings.update((val) {
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
          await _offeringRequest.historyOfferingPlayers(page: page.value);
      offerings.update((val) {
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
      if (page.value >= offerings.value.meta!.lastPage!) {
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

  cancelOfferingPlayer(PlayerOffering? offering) async {
    try {
      EasyLoading.show();
      await _offeringRequest.cancelOfferingPlayer(offerId: offering!.id);
      EasyLoading.dismiss();
      refreshController.requestRefresh();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }
}
