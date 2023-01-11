import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class TargetVoucher {
  String? name;
  String? value;

  TargetVoucher({this.name, this.value});
}

class AddVoucherController extends BaseController {
  final formKey = GlobalKey<FormState>(debugLabel: 'new_voucher');
  final _voucherRequest = VoucherRequest();
  final name = TextEditingController();
  final description = TextEditingController();
  final targets = [
    TargetVoucher(name: 'Pemain', value: 'pemain'),
    TargetVoucher(name: 'Pelatih', value: 'pelatih'),
    TargetVoucher(name: 'Klub', value: 'klub'),
  ].obs;
  final selectedTarget = TargetVoucher().obs;
  final code = TextEditingController();
  final voucherValue = TextEditingController();
  final validFrom = TextEditingController();
  final expired = TextEditingController();
  final isPercentage = true.obs;
  final isUploading = false.obs;

  generateCode() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    code.text = String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  selectTarget(TargetVoucher? target) {
    selectedTarget(target);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _voucherRequest.create(
          name: name.text,
          description: description.text,
          code: code.text,
          isPercentage: isPercentage.value,
          value: int.parse(voucherValue.text),
          target: selectedTarget.value.value,
          validFrom: validFrom.text.isBlank == true
              ? null
              : DateFormat('dd MMMM yyyy').parse(validFrom.text),
          expired: expired.text.isBlank == true
              ? null
              : DateFormat('dd MMMM yyyy').parse(expired.text),
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

  openValidDate() async {
    DateTime? selected = await DatePicker.getDate(Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (selected != null) {
      validFrom.text = DateFormat('dd MMMM yyyy').format(selected);
    }
    Get.focusScope?.unfocus();
  }

  openExpiredDate() async {
    if (validFrom.text.isBlank == true) {
      getSnackbar('Informasi', 'Pilih tanggal mulai valid terlebih dahulu.');
      Get.focusScope?.unfocus();
      return;
    }
    DateTime? selected = await DatePicker.getDate(Get.context!,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (selected != null) {
      expired.text = DateFormat('dd MMMM yyyy').format(selected);
    }
    Get.focusScope?.unfocus();
  }

  onExpansionChanged(bool? changed) {
    if (changed == false) {
      selectedTarget(TargetVoucher());
    }
  }
}
