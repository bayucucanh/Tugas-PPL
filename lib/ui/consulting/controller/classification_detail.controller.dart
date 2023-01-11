import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/consultation_classification_user.dart';
import 'package:mobile_pssi/data/model/consultation_schedule.dart';
import 'package:mobile_pssi/data/model/day.dart';
import 'package:mobile_pssi/data/requests/consult_classification.request.dart';
import 'package:mobile_pssi/ui/withdraw/withdraws.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClassificationDetailController extends BaseController {
  final refreshController = RefreshController();
  final _consultClassificationRequest = ConsultClassificationRequest();
  final _classification = ConsultationClassificationUser().obs;
  final _schedules = <ScheduleForm>[].obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  refreshData() {
    try {
      _initialize();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _initialize() {
    _fetchDetail();
    getProfile();
    getUserData();
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();
      _classification(await _consultClassificationRequest.getMy());
      _schedules(_classification.value.schedules
          ?.map((e) => e.toForm(getDaysOfWeek('id'), e))
          .toList());
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  addSchedule() {
    if (_schedules.length >= 7) {
      getSnackbar('Informasi', 'Jadwal konsultasi telah penuh.');
      return;
    }
    _schedules.add(
      ScheduleForm(
          startTime: TextEditingController(),
          endTime: TextEditingController(),
          days: getDaysOfWeek('id')),
    );
  }

  List<Day> getDaysOfWeek([String? locale]) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index).map((value) {
      String day = DateFormat(DateFormat.WEEKDAY, locale)
          .format(firstDayOfWeek.add(Duration(days: value)));
      return Day(id: (value + 1), name: day);
    }).toList();
  }

  removeSchedule(ScheduleForm schedule) async {
    try {
      EasyLoading.show();
      if (schedule.id != null) {
        await _consultClassificationRequest.deleteSchedule(id: schedule.id!);
      }
      EasyLoading.dismiss();
      _schedules.remove(schedule);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  selectedDay(ScheduleForm? schedule, Day? selectedDay) {
    schedule?.day = selectedDay;
  }

  selectWorkTime(
      TextEditingController? startTime, TextEditingController? endTime) async {
    TimeOfDay? defaultFrom = const TimeOfDay(hour: 06, minute: 00);
    TimeOfDay? defaultTo = const TimeOfDay(hour: 17, minute: 00);
    await DatePicker.getRangeTime(Get.context!,
        initialFrom: defaultFrom,
        initialTo: defaultTo,
        title: 'Pilih Waktu Kerja', onSelect: (start, end) {
      startTime?.text =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      endTime?.text =
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
      Get.back();
    });
  }

  setupWorkTime() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        await _consultClassificationRequest.setupWorkTime(
            schedules: _schedules);
        EasyLoading.dismiss();
        getSnackbar('Informasi', 'Waktu kerja disimpan.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openWithdraw() async {
    await Get.toNamed(Withdraws.routeName);
    _initialize();
  }

  ConsultationClassificationUser? get classificationUser =>
      _classification.value;

  List<ScheduleForm>? get schedules => _schedules;
}
