import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/offering/parts/offer_team_player_detail.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfferListTeamPlayerController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final offerings = Resource<List<PlayerTeam>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchOffering();
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
      _fetchOffering();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOffering() async {
    try {
      EasyLoading.show();
      var resp = await _offeringRequest.offersTeamPlayer(page: page.value);

      offerings.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (page.value >= offerings.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchOffering();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetailOffer(PlayerTeam? playerTeam) {
    Get.dialog(
      OfferingTeamPlayerDetailDialog(vm: this, playerTeam: playerTeam),
    );
  }

  changeStatus(PlayerTeam? playerTeam, int? status) async {
    try {
      EasyLoading.show();
      await _offeringRequest.changeStatusOfferTeamPlayer(
          playerTeamId: playerTeam?.id, status: status);
      EasyLoading.dismiss();
      Get.back();
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
