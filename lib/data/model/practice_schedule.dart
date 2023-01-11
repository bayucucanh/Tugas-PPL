import 'package:mobile_pssi/data/model/day.dart';
import 'package:mobile_pssi/data/model/new_student_form.dart';

class PracticeSchedule {
  int? id;
  NewStudentForm? newStudentForm;
  Day? day;
  String? startTime;
  String? endTime;

  PracticeSchedule({
    this.day,
    this.endTime,
    this.id,
    this.newStudentForm,
    this.startTime,
  });

  factory PracticeSchedule.fromJson(Map<String, dynamic> json) =>
      PracticeSchedule(
        id: json['id'] as int?,
        day: json['day'] == null
            ? null
            : Day.fromJson(json['day'] as Map<String, dynamic>),
        newStudentForm: json['new_student_form'] == null
            ? null
            : NewStudentForm.fromJson(
                json['new_student_form'] as Map<String, dynamic>),
        startTime: json['start_time'] as String?,
        endTime: json['end_time'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day?.toJson(),
    'new_student_form': newStudentForm?.toJson(),
    'start_time': startTime,
    'end_time': endTime,
  };
}
