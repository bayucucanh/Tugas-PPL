import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/events/add_event.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventsController extends BaseController {
  final refreshController = RefreshController();
  final _eventRequest = EventRequest();
  final _events = Resource<List<Event>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchEvents();
    super.onInit();
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
      var resp = await _eventRequest.gets(page: _page.value);
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

  addEvent() async {
    var data = await Get.toNamed(AddEvent.routeName);

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  confirmDelete(Event? event) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Event',
      content: 'Apakah anda yakin ingin menghapus ${event?.name ?? '-'}?',
      onConfirm: () => _delete(event),
    ));
  }

  _delete(Event? event) async {
    try {
      EasyLoading.show();
      await _eventRequest.remove(eventId: event!.id!);
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

  openDetail(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  List<Event>? get events => _events.value.data;
}
