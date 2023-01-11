import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/championship.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ChampionshipAddController extends BaseController {
  final _championshipRequest = ChampionshipRequest();
  final formKey = GlobalKey<FormState>(debugLabel: 'championship_add');
  final name = TextEditingController();
  final position = TextEditingController();
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
        await _championshipRequest.store(
            name: name.text, position: position.text, year: year.text);
        EasyLoading.dismiss();

        Get.back(result: 'success');
        getSnackbar('Informasi', 'Berhasil menambahkan kejuaraan');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
