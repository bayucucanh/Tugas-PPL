import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ChangePasswordController extends BaseController {
  final _userRequest = UserRequest();
  final formKey = GlobalKey<FormState>();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        await _userRequest.changePassword(
          password: newPassword.text,
          passwordConfirmation: confirmNewPassword.text,
        );
        EasyLoading.dismiss();
        Get.back();

        getSnackbar('Informasi', 'Berhasil mengubah perubahan kata sandi');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
