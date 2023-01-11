import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/coach_offering.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfferingCoachController extends BaseController {
  final refreshController = RefreshController();
  final _offerRequest = OfferingRequest();
  final coachOffering = CoachOffering().obs;
  OfferingCoachController() {
    coachOffering(CoachOffering.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchOfferingDetail();
    super.onInit();
  }

  refreshData() {
    try {
      _fetchOfferingDetail();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOfferingDetail() async {
    try {
      EasyLoading.show();
      coachOffering(await _offerRequest.detailOfferCoach(
          offerId: coachOffering.value.id));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  dialogAccept() {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Terima Tawaran Klub",
        middleText:
            "Apakah anda ingin menerima tawaran dari ${coachOffering.value.offerBy?.name ?? '-'} ?",
        middleTextStyle: const TextStyle(
          fontSize: 14,
        ),
        titleStyle: const TextStyle(
          color: Colors.green,
        ),
        textCancel: 'Batal',
        textConfirm: 'Terima',
        buttonColor: Colors.green,
        cancelTextColor: Colors.green,
        radius: 4,
        onConfirm: () => changeStatus(1));
  }

  dialogDeny() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Tolak Tawaran Klub",
      middleText:
          "Apakah anda ingin menolak tawaran dari ${coachOffering.value.offerBy?.name ?? '-'} ?",
      middleTextStyle: const TextStyle(
        fontSize: 14,
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      textCancel: 'Batal',
      textConfirm: 'Tolak',
      buttonColor: Colors.red,
      cancelTextColor: Colors.red,
      radius: 4,
      onConfirm: () => changeStatus(2),
    );
  }

  changeStatus(int status) async {
    try {
      EasyLoading.show();
      await _offerRequest.changeStatusOfferCoach(
          offerId: coachOffering.value.id, status: status);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openOfferingDocument() {
    Get.toNamed(PdfReader.routeName, arguments: coachOffering.value.offerFile);
  }
}
