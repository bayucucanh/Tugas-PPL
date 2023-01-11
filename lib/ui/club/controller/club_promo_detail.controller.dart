import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/requests/new_student.request.dart';
import 'package:mobile_pssi/data/requests/promo.request.dart';
import 'package:mobile_pssi/data/requests/selection.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubPromoDetailController extends BaseController {
  final _promoRequest = PromoRequest();
  final _selectionRequest = SelectionRequest();
  final _newStudentRequest = NewStudentRequest();
  final refreshController = RefreshController();
  final _promo = Promotion().obs;
  final _isParticipating = false.obs;
  final _allowApply = false.obs;
  final uploadData = false.obs;

  ClubPromoDetailController() {
    _promo(Promotion.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() async {
    await _fetchDetail();
    _logView(keyName: 'view_promo');
    _fetchParticipation();
  }

  refreshData() async {
    try {
      _fetchDetail();
      _fetchParticipation();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _logView({String? keyName}) async {
    try {
      await _promoRequest.logPromotion(
          promotionId: _promo.value.id!, keyname: keyName);
    } catch (_) {}
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

  _fetchParticipation() async {
    try {
      EasyLoading.show();
      if (promo?.selectionForm != null) {
        _isParticipating(await _selectionRequest.checkParticipation(
            selectionFormId: _promo.value.selectionForm!.id!));
      } else if (promo?.newStudentForm != null) {
        _isParticipating(await _newStudentRequest.checkParticipation(
            studentFormId: _promo.value.newStudentForm!.id!));
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  participate() async {
    try {
      EasyLoading.show();
      uploadData(true);
      if (promo?.selectionForm != null) {
        _logView(keyName: 'participate');
        await _selectionRequest.participate(
            selectionFormId: _promo.value.selectionForm!.id!);
      } else if (promo?.newStudentForm != null) {
        await _newStudentRequest.participate(
            studentFormId: _promo.value.newStudentForm!.id!);
      }
      _fetchParticipation();
      uploadData(false);
      EasyLoading.dismiss();
    } catch (e) {
      uploadData(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  bool canApplyForm() {
    if (promo?.status?.id == 1) {
      if (_isParticipating.isFalse) {
        return true;
      }
    }

    return false;
  }

  Promotion? get promo => _promo.value;
  bool? get allowApply => _allowApply.value;
}
