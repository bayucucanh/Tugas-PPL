import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/ui/verify_task/verify_video_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VerifyTaskController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final _taskRequest = TaskRequest();
  final taskList = Resource<List<VerifyTask>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchTasks();
    super.onInit();
  }

  refreshTask() {
    try {
      page(1);
      taskList.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchTasks();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchTasks() async {
    try {
      EasyLoading.show();
      var resp = await _taskRequest.getTaskList(page: page.value);
      taskList.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMoreTask() {
    try {
      if (page.value >= taskList.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchTasks();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(VerifyTask taskDetail) {
    Get.toNamed(VerifyVideoDetail.routeName, arguments: taskDetail.toJson());
  }
}
