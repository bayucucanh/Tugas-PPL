import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EditClassCategoryController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _categoryRequest = ClassCategoryRequest();
  final _classCategory = ClassCategory().obs;
  final name = TextEditingController();
  final description = TextEditingController();
  final isUploading = false.obs;
  final selectedFile = FileObservable().obs;

  EditClassCategoryController() {
    _classCategory(ClassCategory.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() {
    name.text = _classCategory.value.name ?? '';
    description.text = _classCategory.value.description ?? '';
  }

  selectFile(FileObservable? file) {
    selectedFile(file);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        EasyLoading.show();
        isUploading(true);
        await _categoryRequest.update(
          categoryClassId: _classCategory.value.id!,
          name: name.text,
          description: description.text,
          image: selectedFile.value,
        );
        isUploading(false);
        EasyLoading.dismiss();

        Get.back(result: 'success');
      }
    } catch (e) {
      isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  ClassCategory get classCategory => _classCategory.value;
}
