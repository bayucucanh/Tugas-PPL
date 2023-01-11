import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/requests/promo.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/transfer_market/new_student_participants.dart';
import 'package:mobile_pssi/ui/transfer_market/promo_performance.dart';
import 'package:mobile_pssi/ui/transfer_market/selection_participants.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailPromoController extends BaseController {
  final _promoRequest = PromoRequest();
  final refreshController = RefreshController();
  final _promo = Promotion().obs;
  DetailPromoController() {
    _promo(Promotion.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _fetchDetail();
    super.onInit();
  }

  refreshData() async {
    try {
      _fetchDetail();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();
      _promo(await _promoRequest.getDetail(promoId: _promo.value.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  confirmStopPromotionDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Hentikan Promosi',
        content:
            'Dengan memberhentikan promosi ini, anda tidak dapat kembali mengubah data promosi ini?',
        cancelText: 'Batal',
        confirmText: 'Hentikan',
        onConfirm: () => changeStatus(3),
      ),
    );
  }

  changeStatus(int? statusId) async {
    try {
      EasyLoading.show();
      await _promoRequest.changeStatus(promoId: promo!.id!, status: statusId);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _fetchDetail();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openParticipants() {
    if (promo?.selectionForm != null) {
      Get.toNamed(SelectionParticipants.routeName,
          arguments: promo?.selectionForm?.toJson());
    } else if (promo?.newStudentForm != null) {
      Get.toNamed(NewStudentParticipants.routeName,
          arguments: promo?.newStudentForm?.toJson());
    }
  }

  openPerformance() {
    Get.toNamed(PromoPerformance.routeName, arguments: promo?.toJson());
  }

  Promotion? get promo => _promo.value;
}
