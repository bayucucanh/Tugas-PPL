import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/duration.dart';
import 'package:mobile_pssi/data/requests/suspend.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddSuspendController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _suspendRequest = SuspendRequest();
  final name = TextEditingController();
  final durations = <SuspendDuration>[
    SuspendDuration(id: null, name: 'Tidak ada'),
    SuspendDuration(id: 'day', name: 'Hari'),
    SuspendDuration(id: 'month', name: 'Bulan'),
    SuspendDuration(id: 'year', name: 'Tahun'),
  ].obs;
  final selectedDuration = SuspendDuration().obs;
  final value = TextEditingController();
  final isUploading = false.obs;

  changeDuration(SuspendDuration? duration) {
    selectedDuration(duration);
    value.clear();
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _suspendRequest.create(
          name: name.text,
          value: int.tryParse(value.text),
          duration: selectedDuration.value.id,
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
