import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/bank_account.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/withdraw.dart';
import 'package:mobile_pssi/data/requests/bank_account.request.dart';
import 'package:mobile_pssi/data/requests/withdraw.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/bank_account/bank_accounts.dart';
import 'package:mobile_pssi/ui/withdraw/parts/otp_form.dart';
import 'package:mobile_pssi/ui/withdraw/parts/transfer_amount_form.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class WithdrawsController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final refreshController = RefreshController();
  final _bankAccountRequest = BankAccountRequest();
  final _withdrawRequest = WithdrawRequest();
  final _withdraws = Resource<List<Withdraw>>(data: []).obs;
  final _bankAccounts = Resource<List<BankAccount>>(data: []).obs;
  final _page = 1.obs;
  final selectedBankAccount = BankAccount().obs;
  final withdrawAmount = TextEditingController();
  final showCheckbox = false.obs;
  final _listChecked = <Withdraw>[].obs;
  final otpText = TextEditingController();
  final reasonText = TextEditingController();
  final uploading = false.obs;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() async {
    await getUserData();
    if (userData.value.hasRole('finance')) {
      await _fetchWithdraw();
    } else {
      _fetchBankAccounts();
      _fetchWithdraw();
    }
  }

  showCheckBoxes() {
    showCheckbox.toggle();
  }

  _fetchBankAccounts() async {
    try {
      EasyLoading.show();
      var resp = await _bankAccountRequest.gets(option: 'select');
      _bankAccounts(resp);

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  refreshData() {
    try {
      _page(1);
      _withdraws.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchWithdraw();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchWithdraw() async {
    try {
      EasyLoading.show();
      String? status;
      if (userData.value.hasRole('finance')) {
        status = 'queued';
      }

      var resp = await _withdrawRequest.gets(
          page: _page.value, sortBy: 'created_at', status: status);
      _withdraws.update((val) {
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
      if (_page.value >= _withdraws.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchWithdraw();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openBankAccount() async {
    await Get.toNamed(BankAccounts.routeName);
    _fetchBankAccounts();
  }

  _selectBank(BankAccount? bankAccount) {
    selectedBankAccount(bankAccount);
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    _openAmountTransfer();
  }

  _openAmountTransfer() async {
    await getProfile();
    await getUserData();
    getBottomSheet(
      TransferAmountForm(vm: this),
      isDismissible: false,
    );
  }

  confirmTransfer() {
    String additionalCharge = 'Rp5.000';
    if (selectedBankAccount.value.bankCode == 'gopay') {
      additionalCharge = 'Rp1.000';
    }
    getDialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Penarikan',
        content:
            'Apakah anda yakin akan menarik dana sebesar ${withdrawAmount.text}? Penarikan akan dikenakan charge tambahan sebesar $additionalCharge, Transfer?',
        onConfirm: transferMoney,
        cancelText: 'Batal',
        confirmText: 'Transfer',
      ),
    );
  }

  transferMoney() async {
    try {
      await _withdrawRequest.payout(
        bankAccountId: selectedBankAccount.value.id!,
        amount: double.parse(_currencyFormatter.format(withdrawAmount.text)),
        notes: 'Penarikan Dana Konsultasi',
      );
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      selectedBankAccount(BankAccount());
      withdrawAmount.clear();
      refreshController.requestRefresh();
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  cancelTransfer() {
    selectedBankAccount(BankAccount());
    withdrawAmount.clear();
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
  }

  openSelectBank() {
    getBottomSheet(
        _bankAccounts.value.data == null || _bankAccounts.value.data!.isEmpty
            ? EmptyWithButton(
                onTap: openBankAccount,
                emptyMessage: 'Belum menambahkan alamat penarikan dana',
                textButton: 'Tambah Alamat Penarikan Dana',
              )
            : VStack([
                'Pilih Rekening Bank'.text.semiBold.lg.make(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final bankAccount = _bankAccounts.value.data?[index];
                    return ListTile(
                      title: (bankAccount?.bankName ?? '-').text.make(),
                      subtitle: VStack([
                        (bankAccount?.name ?? '-').text.make(),
                        (bankAccount?.accountNumber ?? '-').text.make(),
                      ]),
                      onTap: () => _selectBank(bankAccount),
                    );
                  },
                  itemCount: _bankAccounts.value.data?.length ?? 0,
                ),
              ])
                .p12()
                .box
                .withConstraints(const BoxConstraints(
                  minHeight: 300,
                ))
                .make()
                .scrollVertical());
  }

  showOtpForm({Withdraw? withdraw}) async {
    getBottomSheet(
      OtpForm(controller: this),
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  closeOtpForm() {
    otpText.clear();
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
  }

  confirmApprove() {
    getDialog(ConfirmationDefaultDialog(
      title: 'Approve Penarikan Dana',
      confirmText: 'Approve',
      cancelText: 'Batal',
      content: 'Apakah anda yakin akan meng-approve penarikan dana ini?',
      onConfirm: approve,
    ));
  }

  confirmReject() {
    getDialog(ConfirmationDefaultDialog(
      title: 'Reject Penarikan Dana',
      confirmText: 'Reject',
      cancelText: 'Batal',
      contentWidget: VStack([
        'Mohon berikan alasan untuk me-reject penarikan dibawah ini.'
            .text
            .sm
            .center
            .make(),
        TextFormField(
          controller: reasonText,
          decoration: const InputDecoration(
            hintText: 'Alasan Reject',
            labelText: 'Alasan Reject',
          ),
        )
      ]),
      onConfirm: reject,
    ));
  }

  approve() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.show();
      uploading(true);
      await _withdrawRequest.approve(
        withdrawIds: _listChecked.map((e) => e.id!).toList(),
        otp: otpText.text,
      );
      EasyLoading.dismiss();
      uploading(false);
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      otpText.clear();
      _listChecked.clear();
      refreshController.requestRefresh();
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  reject() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.show();
      uploading(true);
      await _withdrawRequest.rejected(
          withdrawIds: _listChecked.map((e) => e.id!).toList(),
          reason: reasonText.text);
      EasyLoading.dismiss();
      uploading(false);
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      reasonText.clear();
      _listChecked.clear();
      refreshController.requestRefresh();
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  addWithdrawId({bool? isSingle = false, Withdraw? withdraw}) {
    if (isSingle == true) {
      _listChecked.assign(withdraw!);
    } else {
      if (_listChecked.contains(withdraw)) {
        _listChecked.remove(withdraw);
      } else {
        _listChecked.add(withdraw!);
      }
    }
  }

  bool get isFinance => userData.value.hasRole('finance');
  List<Withdraw>? get listChecked => _listChecked;
  List<Withdraw>? get withdraws => _withdraws.value.data;
}
