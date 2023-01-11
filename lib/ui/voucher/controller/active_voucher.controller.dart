import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveVoucherController extends BaseController {
  final refreshController = RefreshController();
  final search = TextEditingController();
  final _voucherRequest = VoucherRequest();
  final _vouchers = Resource<List<Voucher>>(data: []).obs;
  final _page = 1.obs;
  final _filterTarget = ''.obs;

  @override
  void onInit() {
    getUserData();
    getFilter();
    _fetchVouchers();
    super.onInit();
  }

  getFilter() {
    if (userData.value.isPlayer) {
      _filterTarget('pemain');
    } else if (userData.value.isClub) {
      _filterTarget('klub');
    } else {
      _filterTarget('pelatih');
    }
  }

  refreshData() {
    _page(1);
    _vouchers.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
    refreshController.resetNoData();
    _fetchVouchers();
    refreshController.refreshCompleted();
  }

  _fetchVouchers() async {
    try {
      EasyLoading.show();
      var resp = await _voucherRequest.gets(
        page: _page.value,
        target: _filterTarget.value,
      );
      _vouchers.update((val) {
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
      if (_page.value >= _vouchers.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchVouchers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  selectVoucher(Voucher? voucher) {
    Get.back(result: voucher);
  }

  List<Voucher>? get vouchers => _vouchers.value.data;
}
