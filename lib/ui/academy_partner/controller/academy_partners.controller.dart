import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/partner.request.dart';
import 'package:mobile_pssi/ui/academy_partner/view_partner.dart';
import 'package:mobile_pssi/ui/banners/new_banner.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AcademyPartnersController extends BaseController {
  final refreshController = RefreshController();
  final _partnerRequest = PartnerRequest();
  final _partners = Resource<List<AcademyPartner>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchPartners();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      _partners.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchPartners();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPartners() async {
    try {
      EasyLoading.show();
      var resp =
          await _partnerRequest.gets(page: page.value, sortBy: 'updated_at');
      _partners.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (page.value >= _partners.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchPartners();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  newData() async {
    var result = await Get.toNamed(NewBanner.routeName);

    if (result == 'success') {
      refreshController.requestRefresh();
    }
  }

  openProfile(Employee? employee) {
    Get.toNamed(CoachProfile.routeName, arguments: employee?.user?.toJson());
  }

  openPartner(AcademyPartner? partner) {
    Get.toNamed(ViewPartner.routeName, arguments: partner?.toJson());
    refreshController.requestRefresh();
  }

  List<AcademyPartner>? get partners => _partners.value.data;
}
