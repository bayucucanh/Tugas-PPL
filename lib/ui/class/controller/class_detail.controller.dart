import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/ui/class/add_video_class_screen.dart';
import 'package:mobile_pssi/ui/class/edit_class.dart';
import 'package:mobile_pssi/ui/class/edit_video_class.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClassDetailController extends BaseController {
  final refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final classData = Class().obs;

  ClassDetailController() {
    classData(Class.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    fetchClassDetail();
    super.onInit();
  }

  refreshData() {
    try {
      EasyLoading.show();

      fetchClassDetail();
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
    } catch (_) {
      EasyLoading.dismiss();

      refreshController.refreshFailed();
    }
  }

  fetchClassDetail() async {
    classData(await _classRequest.getDetail(id: classData.value.id!));
  }

  openAddVideoForm() async {
    var data = await Get.toNamed(AddVideoClassScreen.routeName,
        arguments: classData.value.toJson());

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  editClass() async {
    var data = await Get.toNamed(EditClass.routeName,
        arguments: classData.value.toJson());

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  editVideo(VideoModel video) async {
    var data = await Get.toNamed(EditVideoClassScreen.routeName,
        arguments: video.toJson());

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }
}
