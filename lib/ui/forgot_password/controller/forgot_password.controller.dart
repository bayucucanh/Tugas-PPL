import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/auth.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ForgotPasswordController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _authRequest = AuthRequest();
  final email = TextEditingController();
  final isSendingData = false.obs;

  sendForgotPassword() async {
    try {
      if (formKey.currentState!.validate()) {
        isSendingData(true);
        EasyLoading.show();
        await _authRequest.forgotPassword(email: email.text);
        EasyLoading.dismiss();
        isSendingData(false);
        Get.back();
        getSnackbar('Informasi',
            'Cek inbox email untuk mendapatkan cara merubah kata sandi.');
      }
    } catch (e) {
      isSendingData(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
