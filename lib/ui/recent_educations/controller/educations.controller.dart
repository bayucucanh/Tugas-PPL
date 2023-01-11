
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/education.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/education.request.dart';
import 'package:mobile_pssi/ui/recent_educations/add_education.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EducationsController extends BaseController {
  final _user = User().obs;
  final refreshController = RefreshController();
  final _educationRequest = EducationRequest();
  final educations = Resource<List<Education>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchUserData();
    _fetchEducation();
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
      educations.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchEducation();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (_page.value >= educations.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchEducation();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  _fetchEducation() async {
    try {
      EasyLoading.show();
      var resp = await _educationRequest.gets(
          userId: user.id!, page: _page.value);
      educations.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  void addEducation() async {
    var data = await Get.toNamed(AddEducation.routeName);

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  deleteDialog(Education? education) {
    Get.defaultDialog(
      title: 'Hapus ${education?.schoolName ?? '-'}',
      middleText: 'Apakah benar anda ingin menghapus riwayat ini?',
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: primaryColor,
      buttonColor: primaryColor,
      onConfirm: () => deleteEducation(education),
    );
  }

  deleteEducation(Education? education) async {
    try {
      EasyLoading.show();
      await _educationRequest.remove(id: education!.id!);
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
