import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/player_offering.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OfferingPlayerController extends BaseController {
  final refreshController = RefreshController();
  final _offerRequest = OfferingRequest();
  final playerOffering = PlayerOffering().obs;
  OfferingPlayerController() {
    playerOffering(PlayerOffering.fromJson(Get.arguments));
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
      playerOffering(await _offerRequest.detailOfferPlayer(
          offerId: playerOffering.value.id));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  dialogAccept() {
    Get.dialog(
        ConfirmationDefaultDialog(
          cancelText: 'Batal',
          confirmText: 'Terima',
          title: 'Terima Tawaran Klub',
          content:
              "Apakah anda ingin menerima tawaran dari ${playerOffering.value.offerBy?.name ?? '-'} ?",
          onConfirm: () => changeStatus(1),
        ),
        barrierDismissible: false);
  }

  dialogDeny() {
    Get.dialog(
        ConfirmationDefaultDialog(
          cancelText: 'Batal',
          confirmText: 'Tolak',
          title: 'Tolak Tawaran Klub',
          content:
              "Apakah anda ingin menolak tawaran dari ${playerOffering.value.offerBy?.name ?? '-'} ?",
          onConfirm: () => changeStatus(2),
        ),
        barrierDismissible: false);
  }

  changeStatus(int status) async {
    try {
      EasyLoading.show();
      await _offerRequest.changeStatusOfferPlayer(
          offerId: playerOffering.value.id, status: status);
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
    Get.toNamed(PdfReader.routeName, arguments: playerOffering.value.offerFile);
  }
}
