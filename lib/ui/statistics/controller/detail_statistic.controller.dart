import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/performance_test.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/ui/profile/controller/detail_profile.controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailStatisticController extends BaseController {
  final refreshController = RefreshController();
  final _performanceTestRequest = PerformanceTestRequest();
  final _myPerformance = PerformanceTestVerification().obs;
  final DetailProfileController detailProfileController =
      Get.put(DetailProfileController());
  final _player = const Player().obs;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() {
    _fetchPlayerLocalData();
    _getPerformance();
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

  refreshData() {
    try {
      _getPerformance();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _getPerformance() async {
    try {
      EasyLoading.show();
      _myPerformance(await _performanceTestRequest.getPerfomance(
          playerId: _player.value.id!));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  updateRequest() {
    detailProfileController.openUpdateParameter();
  }

  downloadCV() async {
    try {
      String? url = '${F.baseUrl}/report/${_player.value.userId}';
      if (await canLaunchUrlString(url)) {
        Get.toNamed(PdfReader.routeName, arguments: url, parameters: {
          'link': '$url?download=true',
          'filename':
              'statistik_${DateFormat('ddMMyyyyhms').format(DateTime.now())}.pdf',
        });
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

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

  List<PerformanceTest>? get physiques {
    if (myPerformance == null) {
      return [];
    }
    return myPerformance?.performanceTests
        ?.where(
            (element) => element.performanceItem?.performanceCategory?.id == 2)
        .toList();
  }

  List<PerformanceTest>? get attackTactic {
    if (myPerformance == null) {
      return [];
    }
    return myPerformance?.performanceTests
        ?.where(
            (element) => element.performanceItem?.performanceCategory?.id == 3)
        .toList();
  }

  List<PerformanceTest>? get defendTactic {
    if (myPerformance == null) {
      return [];
    }
    return myPerformance?.performanceTests
        ?.where(
            (element) => element.performanceItem?.performanceCategory?.id == 4)
        .toList();
  }
}
