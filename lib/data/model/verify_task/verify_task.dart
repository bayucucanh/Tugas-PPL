import 'package:mobile_pssi/data/model/employee.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

import 'learning_task.dart';
import 'status.dart';

class VerifyTask {
  int? id;
  Status? status;
  String? reason;
  LearningTask? learningTask;
  Employee? employee;
  String? createdAt;

  VerifyTask({
    this.id,
    this.status,
    this.reason,
    this.learningTask,
    this.employee,
    this.createdAt,
  });

  factory VerifyTask.fromJson(Map<String, dynamic> json) => VerifyTask(
        id: json['id'] as int?,
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        reason: json['reason'] as String?,
        learningTask: json['learning_task'] == null
            ? null
            : LearningTask.fromJson(
                json['learning_task'] as Map<String, dynamic>),
        employee: json['employee'] == null
            ? null
            : Employee.fromJson(json['employee'] as Map<String, dynamic>),
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status?.toJson(),
        'reason': reason,
        'learning_task': learningTask?.toJson(),
        'employee': employee?.toJson(),
        'created_at': createdAt,
      };

  String? get moment => createdAt == null
      ? null
      : timeago.format(DateTime.parse(createdAt!).toLocal());
}
