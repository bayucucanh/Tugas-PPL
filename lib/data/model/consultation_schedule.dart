import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/data/model/consultation_classification_user.dart';
import 'package:mobile_pssi/data/model/day.dart';

class ConsultationSchedule {
  int? id;
  ConsultationClassificationUser? classificationUser;
  Day? day;
  TimeOfDay? workStart;
  TimeOfDay? workEnd;

  ConsultationSchedule({
    this.id,
    this.classificationUser,
    this.day,
    this.workEnd,
    this.workStart,
  });

  factory ConsultationSchedule.fromJson(Map<String, dynamic> json) {
    return ConsultationSchedule(
      id: json['id'] as int?,
      classificationUser: json['classification_user'] == null
          ? null
          : ConsultationClassificationUser.fromJson(
              json['classification_user'] as Map<String, dynamic>),
      day: json['day'] == null ? null : Day.fromJson(json['day']),
      workStart: json['work_start'] == null
          ? null
          : TimeOfDay(
              hour: int.parse(json['work_start']['hour'].toString()),
              minute: int.parse(json['work_start']['minute'].toString())),
      workEnd: json['work_end'] == null
          ? null
          : TimeOfDay(
              hour: int.parse(json['work_end']['hour'].toString()),
              minute: int.parse(json['work_end']['minute'].toString())),
    );
  }

  ScheduleForm toForm(List<Day> days, ConsultationSchedule data) {
    return ScheduleForm(
      id: data.id,
      days: days,
      day: days.firstWhere(
        (day) => day.id == data.day?.id,
        orElse: () => const Day(),
      ),
      startTime: TextEditingController(
        text:
            '${workStart?.hour.toString().padLeft(2, '0')}:${workStart?.minute.toString().padLeft(2, '0')}',
      ),
      endTime: TextEditingController(
          text:
              '${workEnd?.hour.toString().padLeft(2, '0')}:${workEnd?.minute.toString().padLeft(2, '0')}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'classification_user': classificationUser?.toJson(),
        'day': day?.toJson(),
        'work_start': workStart == null
            ? null
            : {
                'hour': workStart?.hour,
                'minute': workStart?.minute,
              },
        'work_end': workEnd == null
            ? null
            : {
                'hour': workEnd?.hour,
                'minute': workEnd?.minute,
              },
      };

  String? get workTime {
    if (workStart != null && workEnd != null) {
      final localizations = MaterialLocalizations.of(Get.context!);
      return '${localizations.formatTimeOfDay(workStart!, alwaysUse24HourFormat: true)} - ${localizations.formatTimeOfDay(workEnd!, alwaysUse24HourFormat: true)}';
    } else {
      return '24 Jam';
    }
  }

  String? get workStartFormat {
    if (workStart == null) {
      return null;
    }
    final localizations = MaterialLocalizations.of(Get.context!);
    return localizations.formatTimeOfDay(workStart!,
        alwaysUse24HourFormat: true);
  }

  String? get workEndFormat {
    if (workEnd == null) {
      return null;
    }
    final localizations = MaterialLocalizations.of(Get.context!);
    return localizations.formatTimeOfDay(workEnd!, alwaysUse24HourFormat: true);
  }
}

class ScheduleForm {
  int? id;
  Day? day;
  TextEditingController? startTime;
  TextEditingController? endTime;
  List<Day> days;

  ScheduleForm(
      {this.id, this.day, this.endTime, this.startTime, required this.days});

  toJson() => {
        'day': day?.id,
        'work_start': startTime?.text,
        'work_end': endTime?.text,
      };
}
