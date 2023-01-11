import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/withdraw/controller/withdraws.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class OtpForm extends StatefulWidget {
  final WithdrawsController controller;
  const OtpForm({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
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
      HStack(
        [
          'Detil Transfer'.text.semiBold.lg.make(),
          IconButton(
            onPressed: widget.controller.closeOtpForm,
            icon: const Icon(
              Icons.close,
              color: primaryColor,
            ),
          ).objectCenterRight(),
        ],
        axisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.spaceBetween,
      ),
      if (widget.controller.withdraws?.length == 1)
        VStack([
          UiSpacer.verticalSpace(space: 10),
          'Transfer dana kepada : ${widget.controller.withdraws?[0].name ?? ''}'
              .text
              .make(),
          'Jumlah Transfer : ${widget.controller.withdraws?[0].amountFormat ?? ''}'
              .text
              .make(),
        ]),
      if (widget.controller.withdraws!.length > 1)
        VStack([
          UiSpacer.verticalSpace(space: 10),
          'Dana akan di transfer ke : ${widget.controller.withdraws?.length} rekening.'
              .text
              .make(),
        ]),
      UiSpacer.verticalSpace(),
      'Masukan kode OTP'.text.semiBold.make(),
      UiSpacer.verticalSpace(),
      TextFormField(
        controller: widget.controller.otpText,
        decoration: const InputDecoration(
          hintText: 'Kode OTP',
          labelText: 'Kode OTP',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 6,
        validator:
            ValidationBuilder(localeName: 'id').required().maxLength(6).build(),
      ),
      UiSpacer.verticalSpace(),
      HStack(
        [
          'Reject'
              .text
              .color(primaryColor)
              .makeCentered()
              .continuousRectangle(
                height: 40,
                width: 100,
                backgroundColor: Vx.white,
                borderSide: const BorderSide(color: primaryColor),
              )
              .onTap(widget.controller.confirmReject),
          'Approve'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                  height: 40, width: 100, backgroundColor: primaryColor)
              .onTap(widget.controller.confirmApprove),
        ],
        axisSize: MainAxisSize.max,
        crossAlignment: CrossAxisAlignment.center,
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
