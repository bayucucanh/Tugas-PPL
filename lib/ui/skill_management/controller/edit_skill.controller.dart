import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/skill.dart';
import 'package:mobile_pssi/data/requests/skill.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EditSkillController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _skillRequest = SkillRequest();
  final _skill = Skill().obs;
  final name = TextEditingController();
  final description = TextEditingController();
  final isUploading = false.obs;

  EditSkillController() {
    _skill(Skill.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() {
    name.text = _skill.value.name ?? '';
    description.text = _skill.value.description ?? '';
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _skillRequest.update(
            skillId: _skill.value.id!,
            name: name.text,
            description: description.text);
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
