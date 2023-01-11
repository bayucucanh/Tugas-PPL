import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/performance_test.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/data/requests/player.request.dart';
import 'package:mobile_pssi/ui/statistics/detail_statistic.dart';
import 'package:mobile_pssi/ui/test_parameter/test_parameter.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class DetailProfileController extends BaseController {
  final refreshController = RefreshController();
  final _playerRequest = PlayerRequest();
  final _performanceTestRequest = PerformanceTestRequest();
  final _myPerformance = PerformanceTestVerification(performanceTests: []).obs;
  final _player = const Player().obs;
  final screenshotController = ScreenshotController();

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  initialize() async {
    try {
      await _fetchPlayerLocalData();
      _fetchPlayerData();
      _getPerformance();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPlayerLocalData() {
    try {
      getUserData();

      if (Get.arguments != null) {
        _player(Player.fromJson(Get.arguments));
      } else {
        _player(userData.value.player);
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchPlayerData() async {
    try {
      EasyLoading.show();
      _player(await _playerRequest.getPlayerById(playerId: _player.value.id));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _getPerformance() async {
    try {
      EasyLoading.show();
      _myPerformance(
          await _performanceTestRequest.getPerfomance(playerId: player!.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  shareImage(BuildContext context) async {
    try {
      EasyLoading.show();
      final box = Get.context?.findRenderObject() as RenderBox?;
      final directory = await getApplicationDocumentsDirectory();
      String? image = await screenshotController.captureAndSave(
        directory.path,
        fileName: 'my-player-card.jpg',
      );
      if (image != null) {
        XFile path =
            XFile(image, name: 'my-player-card.jpg', mimeType: 'image/jpeg');
        await Share.shareXFiles([path],
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      } else {
        getSnackbar('Informasi',
            'Tidak dapat menyimpan gambar file, mohon untuk mengizinkan permisi penyimpanan.');
      }
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  @override
  openDetailStatistics() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(DetailStatistic.routeName, arguments: player?.toJson());
  }

  @override
  openUpdateParameter() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      var data = await Get.toNamed(TestParameter.routeName, arguments: player?.toJson());
      if (data == null) {
        refreshController.requestRefresh();
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  Player? get player => _player.value;
  PerformanceTestVerification? get myPerformance => _myPerformance.value;
  List<PerformanceTest>? get techniques {
    if (myPerformance == null) {
      return [];
    }
    return myPerformance?.performanceTests
        ?.where(
            (element) => element.performanceItem?.performanceCategory?.id == 1)
        .toList();
  }

  double? get mainInfoSize {
    if (Get.mediaQuery.size.shortestSide < 600) {
      return Get.mediaQuery.size.shortestSide / 6;
    }
    return Get.mediaQuery.size.shortestSide / 2.8;
  }
}
