import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/duration_name.dart';
import 'package:mobile_pssi/data/requests/banner.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class NewBannerController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _bannerRequest = BannerRequest();
  final title = TextEditingController();
  final description = TextEditingController();
  final duration = TextEditingController();
  final link = TextEditingController();
  final selectedFile = FileObservable().obs;
  final units = <DurationName>[
    DurationName(name: 'Hari', value: 'day'),
    DurationName(name: 'Bulan', value: 'month'),
    DurationName(name: 'Tahun', value: 'year'),
  ];
  final _selectedUnit = DurationName().obs;
  final uploading = false.obs;

  selectFile(FileObservable? file) {
    selectedFile(file);
  }

  selectUnit(DurationName? unit) {
    _selectedUnit(unit);
  }

  upload() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        uploading(true);
        EasyLoading.show();
        await _bannerRequest.newBanner(
          title: title.text,
          file: selectedFile.value.toFile,
          description: description.text,
          link: link.text,
          duration: duration.text.isEmpty ? null : int.parse(duration.text),
          durationUnit: _selectedUnit.value.value,
        );
        EasyLoading.dismiss();
        uploading(false);
        Get.back(result: 'success');
      }
    } catch (e) {
      EasyLoading.dismiss();
      uploading(false);
      getSnackbar('Informasi', e.toString());
    }
  }
}
