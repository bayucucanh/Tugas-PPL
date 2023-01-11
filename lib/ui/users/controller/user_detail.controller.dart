import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/role.dart';
import 'package:mobile_pssi/data/model/suspend.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/role.request.dart';
import 'package:mobile_pssi/data/requests/suspend.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDetailController extends BaseController {
  final _userRequest = UserRequest();
  final _roleRequest = RoleRequest();
  final _suspendRequest = SuspendRequest();
  final refreshController = RefreshController();
  final _userDetail = User().obs;
  final editAvailable = false.obs;
  final _roles = Resource<List<Role>>(data: []).obs;
  final selectedRoles = <Role>[].obs;
  final List<int> excludeRoleIds = [5, 6];
  final _suspends = Resource<List<Suspend>>(data: []).obs;
  final _suspend = Suspend().obs;

  UserDetailController() {
    _userDetail(User.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchUserDetail();
    _fetchRoles(exclude: excludeRoleIds);
    _fetchSuspends();
    super.onInit();
  }

  refreshData() {
    try {
      _fetchUserDetail();
      _fetchRoles(exclude: excludeRoleIds);
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchUserDetail() async {
    try {
      EasyLoading.show();
      _userDetail(
          await _userRequest.getUserDetail(userId: _userDetail.value.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchRoles({List<int>? exclude}) async {
    try {
      EasyLoading.show();
      var resp = await _roleRequest.getRoles(option: 'select');

      _roles.update((val) {
        val?.data?.clear();
        if (exclude != null) {
          val?.data?.addAll(resp.data!.where((e) => !exclude.contains(e.id)));
        } else {
          val?.data?.addAll(resp.data!.map((e) => e));
        }
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchSuspends() async {
    try {
      EasyLoading.show();
      _suspends(await _suspendRequest.gets(option: 'select'));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  editUser() {
    editAvailable.toggle();
  }

  selectAccess(List<Role> selectedAccess) {
    selectedRoles(selectedAccess);
  }

  save() async {
    try {
      EasyLoading.show();
      await _userRequest.editUser(
          userId: userDetail.id!,
          accessRole: selectedRoles.map((role) => role.id).toList());
      EasyLoading.dismiss();
      editAvailable(false);
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  confirmLiftSuspend() {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Batalkan Suspend Pengguna',
      cancelText: 'Tidak',
      confirmText: 'Batalkan',
      content: 'Batalkan suspend pengguna ini sekarang juga?',
      onConfirm: _liftSuspendUser,
    ));
  }

  _liftSuspendUser() async {
    try {
      EasyLoading.show();
      await _suspendRequest.liftSuspendUser(
        userId: userDetail.id!,
      );
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

  confirmSuspend() {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Suspend Pengguna',
      cancelText: 'Batal',
      confirmText: 'Suspend',
      contentWidget: VStack([
        'Suspend pengguna ini untuk : '.text.make(),
        DropdownButtonFormField(
          items: _suspends.value.data
              ?.map((data) => DropdownMenuItem(
                    value: data,
                    child: (data.name ?? '-').text.make(),
                  ))
              .toList(),
          onChanged: selectSuspend,
        ),
      ]),
      onConfirm: _suspendUser,
    ));
  }

  selectSuspend(Suspend? selectedSuspend) {
    _suspend(selectedSuspend);
  }

  _suspendUser() async {
    try {
      EasyLoading.show();
      await _suspendRequest.suspendUser(
          userId: userDetail.id, suspendId: _suspend.value.id);
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

  User get userDetail => _userDetail.value;
  List<Role>? get roles => _roles.value.data;
}
