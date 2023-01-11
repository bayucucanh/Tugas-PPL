import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/selection_form.dart';
import 'package:mobile_pssi/data/model/selection_participant.dart';
import 'package:mobile_pssi/data/requests/selection.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectionParticipantController extends BaseController {
  final refreshController = RefreshController();
  final selectionForm = SelectionForm().obs;
  final _selectionRequest = SelectionRequest();
  final _participants = Resource<List<SelectionParticipant>>(data: []).obs;
  final _page = 1.obs;

  SelectionParticipantController() {
    selectionForm(SelectionForm.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchParticipants();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _participants.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchParticipants();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchParticipants() async {
    try {
      EasyLoading.show();
      var resp = await _selectionRequest.getParticipations(
          selectionFormId: selectionForm.value.id!, page: _page.value);
      _participants.update((val) {
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
      if (_page.value >= _participants.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchParticipants();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  acceptDialog(SelectionParticipant participant) {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Terima',
        content:
            'Apakah benar anda akan menerima ${participant.profile?.name ?? '-'}?',
        onConfirm: () => _changeStatus(participant: participant, status: 1),
      ),
    );
  }

  rejectDialog(SelectionParticipant participant) {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Penolakan',
        content:
            'Apakah benar anda akan menolak ${participant.profile?.name ?? '-'}?',
        onConfirm: () => _changeStatus(participant: participant, status: 2),
      ),
    );
  }

  acceptAllDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Terima',
        content: 'Apakah benar anda akan menerima semua peserta?',
        onConfirm: _acceptAll,
      ),
    );
  }

  _acceptAll() async {
    try {
      EasyLoading.show();
      await _selectionRequest.acceptAll(
          selectionFormId: selectionForm.value.id!);
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

  _changeStatus(
      {SelectionParticipant? participant, required int? status}) async {
    try {
      EasyLoading.show();
      await _selectionRequest.changeStatusParticipate(
          participantId: participant!.id!, status: status);
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

  List<SelectionParticipant>? get participants => _participants.value.data;
  int? get totalAccepted => participants!.isNotEmpty
      ? participants?.fold(
          0,
          (previousValue, participant) => participant.filterByStatus(1)
              ? previousValue! + 1
              : previousValue)
      : 0;
}
