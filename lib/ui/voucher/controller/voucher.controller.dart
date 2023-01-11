import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/voucher/add_voucher.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VoucherController extends BaseController {
  final refreshController = RefreshController();
  final search = TextEditingController();
  final _voucherRequest = VoucherRequest();
  final _vouchers = Resource<List<Voucher>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchVouchers();
    super.onInit();
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
      var resp =
          await _voucherRequest.gets(page: _page.value, search: search.text);
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

  addVoucher() async {
    var data = await Get.toNamed(AddVoucher.routeName);
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  confirmDelete(Voucher? voucher) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Voucher',
      content: 'Apakah anda yakin ingin voucher ${voucher?.name ?? '-'}?',
      onConfirm: () => _delete(voucher),
    ));
  }

  _delete(Voucher? voucher) async {
    try {
      EasyLoading.show();
      await _voucherRequest.delete(voucherId: voucher!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _vouchers.update((val) {
        val?.data?.remove(voucher);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<Voucher>? get vouchers => _vouchers.value.data;
}
