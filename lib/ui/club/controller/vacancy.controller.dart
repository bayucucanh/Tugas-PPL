import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/selection_participant.dart';
import 'package:mobile_pssi/data/model/student_participant.dart';
import 'package:mobile_pssi/data/requests/new_student.request.dart';
import 'package:mobile_pssi/data/requests/selection.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/club/club_promo_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VacancyController extends BaseController {
  final refreshControllers = [
    RefreshController(),
    RefreshController(),
  ];
  final _selectionRequest = SelectionRequest();
  final _newStudentRequest = NewStudentRequest();
  final _selections = Resource<List<SelectionParticipant>>(data: []).obs;
  final _newStudents = Resource<List<StudentParticipant>>(data: []).obs;
  final _pageSelection = 1.obs;
  final _pageStudent = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchSelections();
    _fetchStudents();
    super.onInit();
  }

  refreshSelection() {
    try {
      _pageSelection(1);
      _selections.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshControllers[0].resetNoData();
      _fetchSelections();
      refreshControllers[0].refreshCompleted();
    } catch (_) {
      refreshControllers[0].refreshFailed();
    }
  }

  _fetchSelections() async {
    try {
      EasyLoading.show();
      var resp = await _selectionRequest.getMyParticipations(
          page: _pageSelection.value);
      _selections.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMoreSelection() {
    try {
      if (_pageSelection.value >= _selections.value.meta!.lastPage!) {
        refreshControllers[0].loadNoData();
      } else {
        _pageSelection(_pageSelection.value + 1);
        _fetchSelections();
        refreshControllers[0].loadComplete();
      }
    } catch (_) {
      refreshControllers[0].loadFailed();
    }
  }

  confirmCancelSelection(SelectionParticipant? participant) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Pembatalan',
      content: 'Apakah anda yakin ingin membatalkan seleksi ini?',
      cancelText: 'Batal',
      confirmText: 'Ya',
      onConfirm: () => _cancelSelection(participant: participant, status: 3),
    ));
  }

  _cancelSelection(
      {SelectionParticipant? participant, required int status}) async {
    try {
      EasyLoading.show();
      await _selectionRequest.changeStatusParticipate(
          participantId: participant!.id!, status: status);
      EasyLoading.dismiss();

      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshControllers[0].requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  refreshStudent() {
    try {
      _pageStudent(1);
      _newStudents.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshControllers[1].resetNoData();
      _fetchStudents();
      refreshControllers[1].refreshCompleted();
    } catch (_) {
      refreshControllers[1].refreshFailed();
    }
  }

  _fetchStudents() async {
    if (userData.value.isPlayer) {
      try {
        EasyLoading.show();
        var resp = await _newStudentRequest.getMyParticipations(
            page: _pageStudent.value);
        _newStudents.update((val) {
          val?.data?.addAll(resp.data!.map((e) => e));
          val?.meta = resp.meta;
        });
        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.dismiss();
        getSnackbar('Informasi', e.toString());
      }
    }
  }

  loadMoreStudent() {
    try {
      if (_pageStudent.value >= _newStudents.value.meta!.lastPage!) {
        refreshControllers[1].loadNoData();
      } else {
        _pageStudent(_pageStudent.value + 1);
        _fetchStudents();
        refreshControllers[1].loadComplete();
      }
    } catch (_) {
      refreshControllers[1].loadFailed();
    }
  }

  confirmCancelStudent(StudentParticipant? participant) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Pembatalan',
      content: 'Apakah anda yakin ingin membatalkan form siswa baru ini?',
      cancelText: 'Batal',
      confirmText: 'Ya',
      onConfirm: () => _cancelStudent(participant: participant, status: 3),
    ));
  }

  _cancelStudent({StudentParticipant? participant, required int status}) async {
    try {
      EasyLoading.show();
      await _newStudentRequest.changeStatusParticipate(
          participantId: participant!.id!, status: status);
      EasyLoading.dismiss();

      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshControllers[1].requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openPromoDetail(Promotion? promotion) {
    Get.toNamed(ClubPromoDetail.routeName, arguments: promotion?.toJson());
  }

  List<SelectionParticipant>? get selections => _selections.value.data;
  List<StudentParticipant>? get newStudents => _newStudents.value.data;
}
