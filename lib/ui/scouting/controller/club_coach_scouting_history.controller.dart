import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/club_coach_offering.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubCoachScoutingHistoryController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final _offerings = Resource<List<ClubCoachOffering>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchOfferingCoaches();
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
          await _offeringRequest.historyOfferingClubCoaches(page: page.value);
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

  cancelOfferingCoach(ClubCoachOffering? offering) async {
    try {
      EasyLoading.show();
      await _offeringRequest.cancelOfferingClubCoach(offerId: offering!.id);
      _offerings.update((val) {
        val?.data?.remove(offering);
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  List<ClubCoachOffering>? get offerings => _offerings.value.data;
}
