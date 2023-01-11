import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/event_participant.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/ui/events/team_event_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum LoadFilter {
  solo,
  group,
}

class EventParticipantsController extends BaseController {
  final refreshControllers = [
    RefreshController(),
    RefreshController(),
  ];
  final _eventRequest = EventRequest();
  final _soloParticipants = Resource<List<EventParticipant>>(data: []).obs;
  final _groupParticipants = Resource<List<EventParticipant>>(data: []).obs;
  final _event = Event().obs;
  final _page = 1.obs;

  EventParticipantsController() {
    _event(Event.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchParticipants(filter: LoadFilter.group);
    _fetchParticipants(filter: LoadFilter.solo);
    super.onInit();
  }

  resetData({LoadFilter? filter}) {
    if (filter == LoadFilter.group) {
      _groupParticipants.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
    }
    _soloParticipants.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
  }

  refreshData(RefreshController refreshController, {LoadFilter? filter}) {
    try {
      _page(1);
      resetData(filter: filter);
      refreshController.resetNoData();
      _fetchParticipants(filter: filter);
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  addData(Resource<List<EventParticipant>> resp, {LoadFilter? filter}) {
    if (filter == LoadFilter.group) {
      _groupParticipants.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
    } else if (filter == LoadFilter.solo) {
      _soloParticipants.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
    }
  }

  _fetchParticipants({LoadFilter? filter}) async {
    try {
      EasyLoading.show();
      var resp = await _eventRequest.getParticipants(
        eventId: _event.value.id!,
        page: _page.value,
        filterByTeam: filter == LoadFilter.group ? true : null,
        filterOnlySolo: filter == LoadFilter.solo ? true : null,
      );
      addData(resp, filter: filter);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore(RefreshController refreshController, {LoadFilter? filter}) {
    try {
      if (filter == LoadFilter.group) {
        if (_page.value >= _groupParticipants.value.meta!.lastPage!) {
          refreshController.loadNoData();
        } else {
          _page(_page.value + 1);
          _fetchParticipants(filter: filter);
          refreshController.loadComplete();
        }
      } else {
        if (_page.value >= _soloParticipants.value.meta!.lastPage!) {
          refreshController.loadNoData();
        } else {
          _page(_page.value + 1);
          _fetchParticipants(filter: filter);
          refreshController.loadComplete();
        }
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(Team? team) {
    Get.toNamed(EventTeamDetail.routeName, arguments: team?.toJson());
  }

  Event? get event => _event.value;
  List<EventParticipant>? get soloParticipants => _soloParticipants.value.data;
  List<EventParticipant>? get groupParticipants =>
      _groupParticipants.value.data;
}
