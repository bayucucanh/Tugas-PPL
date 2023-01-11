import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/skill.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddSkillController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _skillRequest = SkillRequest();
  final name = TextEditingController();
  final description = TextEditingController();
  final isUploading = false.obs;

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        EasyLoading.show();
        isUploading(true);
        await _skillRequest.create(
          name: name.text,
          description: description.text,
        );
        isUploading(false);
        EasyLoading.dismiss();

        Get.back(result: 'success');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
