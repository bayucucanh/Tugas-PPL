import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/experience.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/experience.request.dart';
import 'package:mobile_pssi/ui/experiences/add_experience.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExperiencesController extends BaseController {
  final _user = User().obs;
  final refreshController = RefreshController();
  final _experienceRequest = ExperienceRequest();
  final experiences = Resource<List<Experience>>(data: []).obs;
  final _page = 1.obs;
  final imageTypes = ['png', 'jpg'];

  @override
  void onInit() {
    getUserData();
    _fetchUserData();
    _fetchExperiences();
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
      experiences.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchExperiences();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (_page.value >= experiences.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchExperiences();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  _fetchExperiences() async {
    try {
      EasyLoading.show();
      var resp = await _experienceRequest.getExperienceList(
          userId: user.id!, page: _page.value);
      experiences.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  Future<Uint8List> getPdfThumbnail(String urlFile) async {
    String fileName = basenameWithoutExtension(urlFile);
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName.pdf");

    if (await file.exists()) {
      return file.readAsBytes();
    }

    var uri = Uri.parse(urlFile);
    var data = await http.get(uri);
    if (data.statusCode == 200) {
      var bytes = data.bodyBytes;
      File downloadedFile = await file.writeAsBytes(bytes);
      return downloadedFile.readAsBytes();
    }
    return Uint8List(2);
  }

  void addExperience() async {
    var data = await Get.toNamed(AddExperience.routeName);

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  deleteDialog(Experience? experience) {
    Get.defaultDialog(
      title: 'Hapus ${experience?.name ?? '-'}',
      middleText: 'Apakah benar anda ingin menghapus pengalaman ini?',
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: primaryColor,
      buttonColor: primaryColor,
      onConfirm: () => deleteExperience(experience),
    );
  }

  deleteExperience(Experience? experience) async {
    try {
      EasyLoading.show();
      await _experienceRequest.deleteExperience(id: experience!.id!);
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
