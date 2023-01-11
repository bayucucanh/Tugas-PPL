import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/ui/verify_performance/verify_test_params.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestParameterListController extends BaseController {
  final refreshController = RefreshController();
  final _performanceRequest = PerformanceTestRequest();
  final _performanceList =
      Resource<List<PerformanceTestVerification>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchPerformances();
    super.onInit();
  }

  refreshList() {
    try {
      page(1);
      _performanceList.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchPerformances();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPerformances() async {
    try {
      EasyLoading.show();
      var resp =
          await _performanceRequest.getPerformanceTests(page: page.value);
      _performanceList.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
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
      if (page.value >= _performanceList.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);

        refreshController.loadComplete();
        _fetchPerformances();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(PerformanceTestVerification verifyParams) {
    Get.toNamed(VerifyTestParams.routeName, arguments: verifyParams.toJson());
  }

  List<PerformanceTestVerification>? get performances =>
      _performanceList.value.data;
}
