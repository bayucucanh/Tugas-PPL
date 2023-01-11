import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddClassCategoryController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _categoryRequest = ClassCategoryRequest();
  final name = TextEditingController();
  final description = TextEditingController();
  final isUploading = false.obs;
  final selectedFile = FileObservable().obs;

  selectFile(FileObservable? file) {
    selectedFile(file);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        EasyLoading.show();
        isUploading(true);
        await _categoryRequest.create(
          name: name.text,
          description: description.text,
          image: selectedFile.value,
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
