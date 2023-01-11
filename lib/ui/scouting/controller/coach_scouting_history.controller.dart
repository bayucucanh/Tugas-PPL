import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/coach_offering.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachScoutingHistoryController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final offerings = Resource<List<CoachOffering>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchOfferingCoaches();
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
      _fetchOfferingCoaches();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOfferingCoaches() async {
    try {
      EasyLoading.show();
      var resp =
          await _offeringRequest.historyOfferingCoaches(page: page.value);
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
        _fetchOfferingCoaches();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetailCoach(Employee? coach) {
    Get.toNamed(CoachProfile.routeName,
        arguments: User(id: coach?.userId, employee: coach).toJson());
  }

  cancelOfferingCoach(CoachOffering? offering) async {
    try {
      EasyLoading.show();
      await _offeringRequest.cancelOfferingCoach(offerId: offering!.id);
      EasyLoading.dismiss();
      refreshController.requestRefresh();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }
}
