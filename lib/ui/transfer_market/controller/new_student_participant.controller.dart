import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/new_student_form.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/student_participant.dart';
import 'package:mobile_pssi/data/requests/new_student.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewStudentParticipantController extends BaseController {
  final refreshController = RefreshController();
  final studentForm = NewStudentForm().obs;
  final _newStudentRequest = NewStudentRequest();
  final _participants = Resource<List<StudentParticipant>>(data: []).obs;
  final _page = 1.obs;

  NewStudentParticipantController() {
    studentForm(NewStudentForm.fromJson(Get.arguments));
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
      var resp = await _newStudentRequest.getParticipations(
          studentFormId: studentForm.value.id!, page: _page.value);
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

  acceptDialog(StudentParticipant participant) {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Terima',
        content:
            'Apakah benar anda akan menerima ${participant.player?.name ?? '-'}?',
        onConfirm: () => _changeStatus(participant: participant, status: 1),
      ),
    );
  }

  rejectDialog(StudentParticipant participant) {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Konfirmasi Penolakan',
        content:
            'Apakah benar anda akan menolak ${participant.player?.name ?? '-'}?',
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
      await _newStudentRequest.acceptAll(
          selectionFormId: studentForm.value.id!);
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

  _changeStatus({StudentParticipant? participant, required int? status}) async {
    try {
      EasyLoading.show();
      await _newStudentRequest.changeStatusParticipate(
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

  List<StudentParticipant>? get participants => _participants.value.data;
  int? get totalAccepted => participants!.isNotEmpty
      ? participants?.fold(
          0,
          (previousValue, participant) => participant.filterByStatus(1)
              ? previousValue! + 1
              : previousValue)
      : 0;
}
