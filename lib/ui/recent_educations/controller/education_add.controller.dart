import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/education.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EducationAddController extends BaseController {
  final _educationRequest = EducationRequest();
  final formKey = GlobalKey<FormState>(debugLabel: 'education_add');
  final categories = [
    true,
    false,
  ].obs;
  final schoolName = TextEditingController();
  final degree = TextEditingController();
  final isFormal = true.obs;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  changeCategory(int? value) {
    for (int i = 0; i < categories.length; i++) {
      categories[i] = i == value;
    }
    isFormal(value == 0 ? true : false);
    categories.refresh();
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        await _educationRequest.store(
            schoolName: schoolName.text,
            category: isFormal.value ? 'formal' : 'non-formal',
            degree: degree.text);
        EasyLoading.dismiss();

        Get.back(result: 'success');
        getSnackbar('Informasi', 'Berhasil menambahkan riwayat sekolah');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
