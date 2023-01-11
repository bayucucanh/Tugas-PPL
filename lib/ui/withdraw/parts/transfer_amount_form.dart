import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/withdraw/controller/withdraws.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TransferAmountForm extends StatefulWidget {
  final WithdrawsController vm;
  const TransferAmountForm({Key? key, required this.vm}) : super(key: key);

  @override
  State<TransferAmountForm> createState() => _TransferAmountFormState();
}

class _TransferAmountFormState extends State<TransferAmountForm> {
  double _viewInset = 0.0;
  late BottomInsetObserver _insetObserver;

  @override
  void initState() {
    _insetObserver = BottomInsetObserver()..addListener(_keyboardHandle);
    super.initState();
  }

  @override
  void dispose() {
    _insetObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Detil Penarikan'.text.semiBold.make(),
      UiSpacer.verticalSpace(),
      'Nama Rekening : ${widget.vm.selectedBankAccount.value.name ?? '-'}'
          .text
          .make(),
      'Nomor Rekening dan Bank : ${widget.vm.selectedBankAccount.value.accountNumber ?? '-'} - ${widget.vm.selectedBankAccount.value.bankName?.capitalizeFirst ?? '-'}'
          .text
          .make(),
      UiSpacer.verticalSpace(),
      'Masukan jumlah dana penarikan.'.text.semiBold.make(),
      TextFormField(
        controller: widget.vm.withdrawAmount,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Jumlah Penarikan',
          labelText: 'Jumlah Penarikan',
          helperText: 'Saldo : ${widget.vm.userData.value.balanceFormat ?? 0}',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Tidak boleh kosong.';
          }
          if (value.isNotEmpty) {
            double inputAmount = double.parse(value);
            if (inputAmount > widget.vm.userData.value.balance!) {
              return 'Jumlah dana tidak boleh melebihi saldo.';
            }
          }
          return null;
        },
        inputFormatters: [
          CurrencyTextInputFormatter(
            symbol: 'Rp',
            locale: 'id',
            decimalDigits: 0,
          ),
        ],
        textAlign: TextAlign.end,
      ),
      '*) Minimal penarikan adalah Rp. 10.000'.text.sm.red500.make(),
      UiSpacer.verticalSpace(space: 40),
      HStack(
        [
          'Batal'
              .text
              .color(primaryColor)
              .makeCentered()
              .continuousRectangle(
                  height: 40,
                  width: 100,
                  backgroundColor: Get.theme.backgroundColor,
                  borderSide: const BorderSide(
                    color: primaryColor,
                  ))
              .onTap(widget.vm.cancelTransfer),
          'Tarik Dana'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                  height: 40,
                  width: 100,
                  backgroundColor: primaryColor,
                  borderSide: const BorderSide(
                    color: primaryColor,
                  ))
              .onTap(widget.vm.confirmTransfer),
        ],
        crossAlignment: CrossAxisAlignment.center,
        axisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.spaceAround,
      )
    ]).p12().pOnly(bottom: _viewInset).scrollVertical().safeArea(top: false);
  }

  _keyboardHandle(BottomInsetChanges change) {
    /// getting current inset and check current status
    /// of keyboard visability
    // _isVisible = change.currentInset > 0;
    setState(() {
      _viewInset = change.currentInset;
    });

    /// get delta since last change and check current status of changes
    // if (change.delta == 0) _status = KeyboardStatus.idle;
    // if (change.delta > 0) _status = KeyboardStatus.increase;
    // if (change.delta < 0) _status = KeyboardStatus.decrease;
  }
}
