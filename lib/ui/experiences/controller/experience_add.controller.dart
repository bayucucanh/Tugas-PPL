import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/experience.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ExperienceAddController extends BaseController {
  final _experienceRequest = ExperienceRequest();
  final formKey = GlobalKey<FormState>(debugLabel: 'experience_add');
  final title = TextEditingController();
  final file = FileObservable().obs;
  final description = TextEditingController();
  final imageTypes = ['png', 'jpg'];

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  selectFile() async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      allowedExtensions: [
        'jpg',
        'png',
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectedFile != null) {
      file(FileObservable.filePickerResult(selectedFile));
    }
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        FormData formData = FormData.fromMap({
          'title': title.text,
          'description': description.text,
          'experience_file': await MultipartFile.fromFile(file.value.path!,
              filename: file.value.name),
        });
        await _experienceRequest.addExperience(data: formData);
        EasyLoading.dismiss();

        Get.back(result: 'success');
        getSnackbar('Informasi', 'Berhasil menambahkan pengalaman');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
