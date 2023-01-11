import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/class/add_class_screen.dart';
import 'package:mobile_pssi/ui/class/class_detail_screen.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachClassController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final _coachRequest = CoachRequest();
  final _classRequest = ClassRequest();
  final _classes = Resource<List<Class>>(data: []).obs;
  final currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    _fetchClass();
  }

  refreshData() {
    try {
      currentPage(1);
      _classes.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });

      refreshController.resetNoData();

      _fetchClass();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchClass() async {
    try {
      EasyLoading.show();
      Resource<List<Class>> resp;
      if (userData.value.hasRole('administrator')) {
        resp = await _classRequest.getClass(page: currentPage.value);
      } else {
        resp = await _coachRequest.getClass(userData.value.id!,
            page: currentPage.value, activeClass: false);
      }
      _classes.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (currentPage.value >= _classes.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        currentPage(currentPage.value + 1);
        _fetchClass();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  void goToAddForm() {
    Get.toNamed(AddClassScreen.routeName);
  }

  void getDetail(Class classData) {
    Get.toNamed(ClassDetailScreen.routeName, arguments: classData.toJson());
  }

  confirmDelete(Class? classData) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Kelas',
      content: 'Apakah anda yakin ingin menghapus ${classData?.name ?? '-'}?',
      onConfirm: () => _delete(classData),
    ));
  }

  _delete(Class? classData) async {
    try {
      EasyLoading.show();
      await _coachRequest.deleteClass(classId: classData!.id!);
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

  List<Class>? get classes => _classes.value.data;
}
