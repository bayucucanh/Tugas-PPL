import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/my_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/rating.request.dart';
import 'package:mobile_pssi/ui/class/class_screen.dart';
import 'package:mobile_pssi/ui/class/parts/rating.dialog.dart';
import 'package:mobile_pssi/ui/reviews/controller/review_class.controller.dart';
import 'package:mobile_pssi/ui/watch/watch.screen.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyClassController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final _ratingRequest = RatingRequest();
  final classes = Resource<List<MyClass>>(data: []).obs;
  final currentPage = 1.obs;
  final rateController = Get.put(ReviewClassController());
  final tabs = <ClassLevel>[].obs;
  final currentTab = 0.obs;
  final _selectedClassLevel = ClassLevel().obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  _initialize() async {
    await _fetchTabs();
    _fetchMyClass();
  }

  changeClassLevel(int index) {
    currentTab(index);
    _selectedClassLevel(tabs[index]);
    refreshController.requestRefresh();
  }

  _fetchTabs() async {
    try {
      EasyLoading.show();
      var resp = await _classRequest.getClassLevels(
          page: currentPage.value, option: 'select', orderBy: 'asc');
      tabs(resp.data);
      if (tabs.isNotEmpty) {
        _selectedClassLevel(tabs[0]);
      }
      EasyLoading.dismiss();
    } on Exception catch (_) {
      EasyLoading.dismiss();
    }
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
      var resp = await _classRequest.getMyClass(
          page: currentPage.value, classLevelId: _selectedClassLevel.value.id);
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

  viewClass(MyClass? myClass) {
    Get.toNamed(WatchScreen.routeName, arguments: myClass?.toClass().toJson());
  }

  openRatingDialog(MyClass myClass) {
    Get.dialog(RatingDialog(
      vm: this,
      myClass: myClass,
    ));
  }

  rateClass(MyClass myClass) async {
    try {
      EasyLoading.show();
      await _ratingRequest.ratingClass(
        classId: myClass.classId,
        description: rateController.description.text,
        rating: rateController.rating.value,
      );
      EasyLoading.dismiss();
      rateController.resetDefault();
      Get.back();
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  goClasses() {
    Get.toNamed(ClassScreen.routeName);
  }
}
