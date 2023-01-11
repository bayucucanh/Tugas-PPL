import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/achievement.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/achievement.request.dart';
import 'package:mobile_pssi/ui/achievement/add_achievement.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AchievementController extends BaseController {
  final _user = User().obs;
  final refreshController = RefreshController();
  final _achievementRequest = AchievementRequest();
  final achievements = Resource<List<Achievement>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchUserData();
    _fetchAchievements();
    super.onInit();
  }

  _fetchUserData() {
    if (Get.arguments != null) {
      _user.value = User.fromJson(Get.arguments);
    } else {
      _user.value = userData.value;
    }
  }

  refreshData() {
    try {
      _page(1);
      achievements.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchAchievements();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (_page.value >= achievements.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchAchievements();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  _fetchAchievements() async {
    try {
      EasyLoading.show();
      var resp =
          await _achievementRequest.gets(userId: user.id!, page: _page.value);
      achievements.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  void addNewAchievement() async {
    var data = await Get.toNamed(AddAchievement.routeName);

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  deleteDialog(Achievement? achievement) {
    Get.defaultDialog(
      title: 'Hapus ${achievement?.name ?? '-'}',
      middleText: 'Apakah benar anda ingin menghapus pengalaman ini?',
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: primaryColor,
      buttonColor: primaryColor,
      onConfirm: () => deleteAchievement(achievement),
    );
  }

  deleteAchievement(Achievement? achievement) async {
    try {
      EasyLoading.show();
      await _achievementRequest.remove(id: achievement!.id!);
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

  User get user => _user.value;
}
