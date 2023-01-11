import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/bank_account.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/bank_account.request.dart';
import 'package:mobile_pssi/ui/bank_account/add_bank_account.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BankAccountsController extends BaseController {
  final refreshController = RefreshController();
  final _bankAccountRequest = BankAccountRequest();
  final _bankAccounts = Resource<List<BankAccount>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchBankAccount();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _bankAccounts.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchBankAccount();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchBankAccount() async {
    try {
      EasyLoading.show();
      var resp = await _bankAccountRequest.gets(page: _page.value);
      _bankAccounts.update((val) {
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
      if (_page.value >= _bankAccounts.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchBankAccount();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addBankAccount() async {
    var data = await Get.toNamed(AddBankAccount.routeName);
    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  List<BankAccount>? get bankAccounts => _bankAccounts.value.data;
}
