import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/class_category/add_class_category.dart';
import 'package:mobile_pssi/ui/class_category/edit_class_category.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClassCategoryManagementController extends BaseController {
  final refreshController = RefreshController();
  final _categoryRequest = ClassCategoryRequest();
  final _categories = Resource<List<ClassCategory>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchCategories();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _categories.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchCategories();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchCategories() async {
    try {
      EasyLoading.show();
      var resp = await _categoryRequest.gets(page: _page.value, option: null);
      _categories.update((val) {
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
      if (_page.value >= _categories.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchCategories();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addClassCategory() async {
    var data = await Get.toNamed(AddClassCategory.routeName);
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  editClassCategory(ClassCategory? category) async {
    var data =
        await Get.toNamed(EditClassCategory.routeName, arguments: category?.toJson());
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  confirmDelete(ClassCategory? category) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Topik Keahlian',
      content: 'Hapus topik keahlian ${category?.name ?? '-'}?',
      onConfirm: () => _removeSkill(category),
    ));
  }

  _removeSkill(ClassCategory? category) async {
    try {
      EasyLoading.show();
      await _categoryRequest.remove(classCategoryId: category!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _categories.update((val) {
        val?.data?.remove(category);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<ClassCategory>? get categories => _categories.value.data;
}
