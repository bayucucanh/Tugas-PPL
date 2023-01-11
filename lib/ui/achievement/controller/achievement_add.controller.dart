import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/achievement.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AchievementAddController extends BaseController {
  final _achievementRequest = AchievementRequest();
  final formKey = GlobalKey<FormState>(debugLabel: 'achievement_add');
  final title = TextEditingController();
  final year = TextEditingController();

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        await _achievementRequest.store(name: title.text, year: year.text);
        EasyLoading.dismiss();

        Get.back(result: 'success');
        getSnackbar('Informasi', 'Berhasil menambahkan penghargaan');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
