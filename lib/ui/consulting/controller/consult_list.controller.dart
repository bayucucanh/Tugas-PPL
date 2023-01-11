import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/consultation.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/consult.request.dart';
import 'package:mobile_pssi/ui/consulting/auto_texts.dart';
import 'package:mobile_pssi/ui/consulting/consult_room.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConsultListController extends BaseController {
  final _consultRequest = ConsultRequest();
  final refreshController = RefreshController();
  final _consultations = Resource<List<Consultation>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchConsultation();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      _consultations.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchConsultation();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchConsultation() async {
    try {
      EasyLoading.show();
      Resource<List<Consultation>> resp;
      if (userData.value.isPlayer) {
        resp = await _consultRequest.getMyConsultations(page: page.value);
      } else {
        resp = await _consultRequest.getConsultations(page: page.value);
      }
      _consultations.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (page.value >= _consultations.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchConsultation();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openChat(Consultation? consultation) {
    Get.toNamed(ConsultRoom.routeName, arguments: consultation?.toJson());
  }

  openAutoTexts() {
    Get.toNamed(AutoTexts.routeName);
  }

  List<Consultation>? get consultations => _consultations.value.data;
}
