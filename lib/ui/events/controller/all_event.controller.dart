import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllEventController extends BaseController {
  final refreshController = RefreshController();
  final _eventRequest = EventRequest();
  final _events = Resource<List<Event>>(data: []).obs;
  final _page = 1.obs;
  final _target = ''.obs;

  @override
  void onInit() {
    getUserData();
    _checkTarget();
    _fetchEvents();
    super.onInit();
  }

  _checkTarget() {
    if (userData.value.isPlayer) {
      _target('pemain');
    } else if (userData.value.isCoach) {
      _target('pelatih');
    } else if (userData.value.isClub) {
      _target('klub');
    }
  }

  refreshData() {
    try {
      _page(1);
      _events.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchEvents();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchEvents() async {
    try {
      EasyLoading.show();
      var resp =
          await _eventRequest.gets(page: _page.value, target: _target.value);
      _events.update((val) {
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
      if (_page.value >= _events.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchEvents();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  List<Event>? get events => _events.value.data;
}
