import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TeamEventDetailController extends BaseController {
  final refreshController = RefreshController();
  final _teamRequest = TeamRequest();
  final team = const Team(
    coaches: [],
    players: [],
  ).obs;

  TeamEventDetailController() {
    team(Team.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchDetail();
    super.onInit();
  }

  refreshData() {
    try {
      _fetchDetail();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();
      team(await _teamRequest.getDetailTeam(
          teamId: team.value.id!, withSecureDocument: true));
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  openKtp(User? user) async {
    try {
      if (user != null) {
        if (user.ktp != null) {
          if (user.ktp?.file != null) {
            if (await canLaunchUrlString(user.ktp!.file!)) {
              await launchUrlString(user.ktp!.file!);
            }
          }
        }
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  openCV(int? userId) async {
    try {
      String? reportUrl = '${F.baseUrl}/report/$userId';
      if (await canLaunchUrlString(reportUrl)) {
        await launchUrlString(reportUrl);
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }
}
