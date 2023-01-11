import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachesController extends BaseController {
  final refreshController = RefreshController();
  final _coachRequest = CoachRequest();
  final _coaches = Resource<List<User>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  openCoach(User? user) {
    Get.toNamed(CoachProfile.routeName, arguments: user?.toJson());
  }

  refreshData() {
    try {
      _page(1);
      _coaches.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchData();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchData() async {
    try {
      EasyLoading.show();
      var resp = await _coachRequest.getCoachList(
          page: _page.value, onlyPartner: true);
      _coaches.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      _coaches.update((val) {
        val?.data?.sort((a, b) {
          if (a.isOnline == true) {
            return 1;
          } else {
            if (b.isOnline == true) {
              return 1;
            }
            return 0;
          }
        });
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _coaches.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchData();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  List<User>? get coaches => _coaches.value.data;
}
