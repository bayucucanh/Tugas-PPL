import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promo_type.dart';
import 'package:mobile_pssi/data/requests/promo.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_selection_form/new_selection_form.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/new_student_form.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/promo_types/promo_type.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/target_promo/target_promo.controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddPromoController extends BaseController {
  final _promoRequest = PromoRequest();
  final pageController = PageController(initialPage: 0);
  final title = 'Pilih Target Promosi'.obs;
  final page = 0.obs;
  final targetPromo = Get.put(TargetPromoController());
  final typePromo = Get.put(PromoTypeController());
  final selectionForm = Get.put(NewSelectionFormController());
  final studentForm = Get.put(NewStudentFormController());
  final selectionFormKey = GlobalKey<FormState>(debugLabel: 'selectionForm');
  final newStudentFormKey = GlobalKey<FormState>(debugLabel: 'newStudentForm');
  final uploading = false.obs;

  nextPage() {
    if (page.value < 3) {
      page(page.value + 1);
      pageController.nextPage(
          duration: const Duration(milliseconds: 333), curve: Curves.linear);
      _setTitle();
    }
  }

  backPage() {
    if (page.value > 0) {
      page(page.value - 1);
      pageController.previousPage(
          duration: const Duration(milliseconds: 333), curve: Curves.linear);
      _setTitle();
    } else {
      Get.back();
    }
  }

  void _setTitle() {
    switch (page.value) {
      case 1:
        title('Tipe Promosi');
        break;
      case 2:
        typePromo.selectedType?.id == 1
            ? title('Form Siswa Baru')
            : title('Form Seleksi');
        break;
      case 0:
      default:
        typePromo.selectType(PromoType());
        title('Pilih Target Promosi');
    }
  }

  cancelDialog() {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Konfirmasi Pembatalan',
      content: 'Apakah anda ingin membatalkan pembuatan promosi?',
      onConfirm: _cancel,
    ));
  }

  _cancel() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    page(-1);
    Get.back();
  }

  Future<bool> exitPromo() async {
    return page.value < 0 ? true : false;
  }

  createPromo() async {
    try {
      Map<String, dynamic> data = {};
      data.addAll(targetPromo.toJson());
      data.addAll(typePromo.toJson());

      if (typePromo.selectedType?.id == 1) {
        if (newStudentFormKey.currentState!.validate()) {
          uploading(true);
          EasyLoading.show();
          data.addAll(studentForm.toJson());
          await _promoRequest.createPromo(data: data);
          uploading(false);
          EasyLoading.dismiss();
          _cancel();
          getSnackbar('Informasi', 'Berhasil membuat promosi.');
        }
      } else {
        if (selectionFormKey.currentState!.validate()) {
          uploading(true);
          EasyLoading.show();
          data.addAll(selectionForm.toJson());
          await _promoRequest.createPromo(data: data);
          uploading(false);
          EasyLoading.dismiss();
          _cancel();
          getSnackbar('Informasi', 'Berhasil membuat promosi.');
        }
      }
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
