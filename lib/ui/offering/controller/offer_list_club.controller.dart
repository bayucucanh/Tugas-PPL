import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/player_offering.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_coach.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfferListClubController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final offerings = Resource<dynamic>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
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
      _fetchOffering();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOffering() async {
    try {
      EasyLoading.show();
      Resource<List<Object>>? resp;
      if (userData.value.isPlayer) {
        resp = await _offeringRequest.offerListPlayer(page: page.value);
      } else if (userData.value.isCoach) {
        resp = await _offeringRequest.offerListCoach(page: page.value);
      }

      offerings.update((val) {
        val?.data?.addAll(resp?.data!.map((e) => e).toList());
        val?.meta = resp?.meta;
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

  openOffering(dynamic offering) {
    if (offering is PlayerOffering) {
      Get.toNamed(OfferingJoinClubPlayer.routeName, arguments: offering.toJson());
    } else {
      Get.toNamed(OfferingJoinClubCoach.routeName, arguments: offering.toJson());
    }
  }
}
