import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoachClassController extends BaseController {
  final refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final _classes = Resource<List<Class>>(data: []).obs;
  final _page = 1.obs;
  final _coachUser = User().obs;

  CoachClassController() {
    _coachUser(User.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _classes.update((val) {
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
      var resp = await _classRequest.getClassCreator(
          creatorId: _coachUser.value.id!, page: _page.value);
      _classes.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _classes.value.meta!.lastPage!) {
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

  List<Class>? get classes => _classes.value.data;
}
