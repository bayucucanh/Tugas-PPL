import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/my_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScannerPlayerClassController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final classes = Resource<List<MyClass>>(data: []).obs;
  final currentPage = 1.obs;
  String? code;

  ScannerPlayerClassController() {
    code = Get.arguments;
  }

  @override
  void onInit() {
    _fetchMyClass();
    super.onInit();
  }

  refreshData() {
    try {
      currentPage(1);
      classes.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });

      refreshController.resetNoData();

      _fetchMyClass();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchMyClass() async {
    try {
      EasyLoading.show();
      var resp = await _classRequest.getPlayerClassFromQRCode(
          code: code, page: currentPage.value);
      classes.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } on Exception catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (currentPage.value >= classes.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        currentPage(currentPage.value + 1);

        _fetchMyClass();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.refreshFailed();
    }
  }
}
