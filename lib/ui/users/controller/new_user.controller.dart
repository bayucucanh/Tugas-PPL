import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/role.dart';
import 'package:mobile_pssi/data/model/user_type.dart';
import 'package:mobile_pssi/data/requests/role.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class NewUserController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _userRequest = UserRequest();
  final _roleRequest = RoleRequest();
  final _roles = Resource<List<Role>>(data: []).obs;
  final selectedRoles = <Role>[].obs;
  final List<int> excludeRoleIds = [5, 6];
  final userTypes = <UserType>[
    UserType(id: 1, name: 'Karyawan'),
    UserType(id: 2, name: 'Pemain'),
    UserType(id: 3, name: 'Klub'),
  ].obs;
  final selectedUserType = UserType().obs;
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final name = TextEditingController();
  final birthOfDate = TextEditingController();
  final phoneNumber = TextEditingController(text: '+62');

  @override
  void onInit() {
    _fetchRoles(exclude: excludeRoleIds);
    super.onInit();
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

  selectUserType(UserType? userType) {
    selectedUserType(userType);
    selectedRoles.clear();
  }

  selectAccess(List<Role>? selectedAccess) {
    selectedRoles(selectedAccess);
  }

  generatePasswordButton() {
    String generatedPassword = generatePassword(minLength: 16);
    password.text = generatedPassword;
    rePassword.text = generatedPassword;
  }

  final df = DateFormat('yyyy-MM-dd');

  selectDate() async {
    final DateTime? selected = await DatePicker.getDate(Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 1));
    if (selected != null) {
      birthOfDate.text = df.format(selected);
    }
  }

  createAccount() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        await _userRequest.createUser(
          email: email.text,
          name: name.text,
          username: username.text,
          userType: selectedUserType.value.id,
          password: password.text,
          rePassword: rePassword.text,
          phoneNumber: phoneNumber.text,
          birthOfDate: birthOfDate.text,
          accessRole: selectedRoles.map((role) => role.id).toList(),
        );
        resetForm();
        EasyLoading.dismiss();
        getSnackbar('Informasi', 'Akun telah berhasil dibuat.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  resetForm() {
    email.clear();
    name.clear();
    username.clear();
    selectedUserType(UserType());
    password.clear();
    rePassword.clear();
    phoneNumber.clear();
    birthOfDate.clear();
    selectedRoles.clear();
  }

  String generatePassword({
    int minLength = 8,
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    final length = minLength;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  List<Role>? get roles => _roles.value.data;
}
