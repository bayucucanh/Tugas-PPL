import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/bank_account.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/bank_account.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddBankAccountController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _bankAccountRequest = BankAccountRequest();
  final accountNumber = TextEditingController();
  final _banks = Resource<List<BankAccount>>(data: []).obs;
  final bankAccount = BankAccount().obs;
  final uploading = false.obs;

  @override
  void onInit() {
    _fetchBankList();
    super.onInit();
  }

  _fetchBankList() async {
    try {
      EasyLoading.show();
      var resp = await _bankAccountRequest.supportedBanks();
      _banks.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  selectBank(BankAccount? bank) {
    bankAccount(bank);
  }

  upload() async {
    try {
      if (formKey.currentState!.validate()) {
        uploading(true);
        EasyLoading.show();
        await _bankAccountRequest.store(
          accountNumber: accountNumber.text,
          bankCode: bankAccount.value.bankCode,
        );
        EasyLoading.dismiss();
        uploading(false);
        Get.back(result: 'success');
      }
    } catch (e) {
      EasyLoading.dismiss();
      uploading(false);
      getSnackbar('Informasi', e.toString());
    }
  }

  List<BankAccount>? get banks => _banks.value.data;
}
