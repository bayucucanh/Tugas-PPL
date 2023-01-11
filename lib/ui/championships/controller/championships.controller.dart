import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/championship.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/championship.request.dart';
import 'package:mobile_pssi/ui/championships/add_championship.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChampionshipsController extends BaseController {
  final _user = User().obs;
  final refreshController = RefreshController();
  final _championshipRequest = ChampionshipRequest();
  final championships = Resource<List<Championship>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchUserData();
    _fetchChampionship();
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
      championships.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchChampionship();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (_page.value >= championships.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchChampionship();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  _fetchChampionship() async {
    try {
      EasyLoading.show();
      var resp =
          await _championshipRequest.gets(userId: user.id!, page: _page.value);
      championships.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  void addChampionship() async {
    var data = await Get.toNamed(AddChampionship.routeName);

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  deleteDialog(Championship? championship) {
    Get.defaultDialog(
      title: 'Hapus ${championship?.name ?? '-'}',
      middleText: 'Apakah benar anda ingin menghapus kejuaraan ini?',
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: primaryColor,
      buttonColor: primaryColor,
      onConfirm: () => deleteChampionship(championship),
    );
  }

  deleteChampionship(Championship? championship) async {
    try {
      EasyLoading.show();
      await _championshipRequest.remove(id: championship!.id!);
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
