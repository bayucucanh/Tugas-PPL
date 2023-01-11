import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/ui/users/new_user.dart';
import 'package:mobile_pssi/ui/users/user_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserController extends BaseController {
  final refreshController = RefreshController();
  final search = TextEditingController();
  final _userRequest = UserRequest();
  final users = Resource<List<User>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    _fetchUsers();
    super.onInit();
  }

  refreshData() {
    page(1);
    users.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
    refreshController.resetNoData();
    _fetchUsers();
    refreshController.refreshCompleted();
  }

  _fetchUsers() async {
    try {
      EasyLoading.show();
      var resp =
          await _userRequest.getUsers(page: page.value, search: search.text);
      users.update((val) {
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
      if (page.value >= users.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchUsers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openUserDetail(User? user) {
    Get.toNamed(UserDetail.routeName, arguments: user?.toJson());
  }

  newUser() {
    Get.toNamed(NewUser.routeName);
  }

  List<User>? get userList => users.value.data;
}
