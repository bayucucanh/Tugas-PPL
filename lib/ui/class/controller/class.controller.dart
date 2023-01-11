import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/ui/class/add_class_screen.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClassController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final query = TextEditingController();
  final _classes = Resource<List<Class>>(data: []).obs;
  final _classLevels = Resource<List<ClassLevel>>(data: []).obs;
  final _filterPremium = false.obs;
  final _filterTopic = ''.obs;
  final _currentPage = 1.obs;
  final _selectedLevel = ClassLevel().obs;
  final queryBlank = true.obs;

  ClassController() {
    _filterPremium(Get.arguments);
    _filterTopic(Get.parameters['class_category_id']);
  }

  @override
  void onInit() {
    super.onInit();
    _fetchClassLevels();
    _fetchClass();
    debounce(query.obs, (TextEditingController q) => search(data: q.text));
  }

  refreshData({String? search}) {
    try {
      _currentPage(1);
      _classes.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });

      refreshController.resetNoData();

      _fetchClass(search: search);
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchClassLevels() async {
    try {
      EasyLoading.show();
      var resp =
          await _classRequest.getClassLevels(option: 'select', orderBy: 'asc');
      _classLevels.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  _fetchClass({String? search}) async {
    try {
      EasyLoading.show();
      var resp = await _classRequest.getClass(
        page: _currentPage.value,
        search: search,
        classLevelId: _selectedLevel.value.id,
        onlyPremium: Get.arguments == null ? null : _filterPremium.value,
        classCategoryId:
            _filterTopic.isEmpty ? null : int.parse(_filterTopic.value),
      );
      _classes.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  search({String? data}) {
    Get.focusScope?.unfocus();
    queryBlank(query.isBlank == true ? true : false);
    refreshData(search: data ?? query.text);
  }

  selectLevel(ClassLevel? classLevel) {
    _selectedLevel(classLevel);
    search();
  }

  resetForm() {
    query.clear();
    _selectedLevel(ClassLevel());
    queryBlank(true);
    refreshData();
  }

  loadMore() {
    try {
      if (_currentPage.value >= _classes.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _currentPage(_currentPage.value + 1);
        _fetchClass(search: query.text);
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  void goToAddForm() {
    Get.toNamed(AddClassScreen.routeName);
  }

  ClassLevel? get selectedLevel => _selectedLevel.value;
  List<Class>? get classes => _classes.value.data;
  List<ClassLevel>? get classLevels => _classLevels.value.data;
}
