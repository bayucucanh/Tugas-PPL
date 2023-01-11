import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/promo.request.dart';
import 'package:mobile_pssi/ui/club/club_promo_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubListController extends BaseController {
  final refreshController = RefreshController();
  final _promoRequest = PromoRequest();
  final search = TextEditingController();
  final _promotions = Resource<List<Promotion>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchPromos();
    super.onInit();
  }

  refreshData() async {
    try {
      _page(1);
      _promotions.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchPromos();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPromos() async {
    try {
      EasyLoading.show();
      var resp = await _promoRequest.getClubPromotions(
          page: _page.value, search: search.text);
      _promotions.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _promotions.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchPromos();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openPromoDetail(Promotion promotion) {
    Get.toNamed(ClubPromoDetail.routeName, arguments: promotion.toJson());
  }

  List<Promotion>? get promotions => _promotions.value.data;
}
