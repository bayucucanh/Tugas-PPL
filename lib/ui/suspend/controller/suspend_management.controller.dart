import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/suspend.dart';
import 'package:mobile_pssi/data/requests/suspend.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/skill_management/edit_skill.dart';
import 'package:mobile_pssi/ui/suspend/add_suspend.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SuspendManagementController extends BaseController {
  final refreshController = RefreshController();
  final _suspendRequest = SuspendRequest();
  final _suspends = Resource<List<Suspend>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchSuspends();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _suspends.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchSuspends();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchSuspends() async {
    try {
      EasyLoading.show();
      var resp = await _suspendRequest.gets(page: _page.value);
      _suspends.update((val) {
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
      if (_page.value >= _suspends.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchSuspends();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addSuspend() async {
    var data = await Get.toNamed(AddSuspend.routeName);
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  editSuspend(Suspend? skill) {
    Get.toNamed(EditSkill.routeName, arguments: skill?.toJson());
  }

  confirmDelete(Suspend? suspend) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Suspend',
      content: 'Hapus suspend ${suspend?.name ?? '-'}?',
      onConfirm: () => _removeSkill(suspend),
    ));
  }

  _removeSkill(Suspend? suspend) async {
    try {
      EasyLoading.show();
      await _suspendRequest.remove(suspendId: suspend!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _suspends.update((val) {
        val?.data?.remove(suspend);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<Suspend>? get suspends => _suspends.value.data;
}
