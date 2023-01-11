import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:timeago_flutter/timeago_flutter.dart';

class AcademyPartner extends Equatable {
  final int? id;
  final Employee? employee;
  final String? reason;
  final Status? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AcademyPartner({
    this.id,
    this.employee,
    this.reason,
    this.status,
    this.updatedAt,
    this.createdAt,
  });

  factory AcademyPartner.fromJson(Map<String, dynamic> json) => AcademyPartner(
        id: json['id'] as int?,
        employee: json['employee'] == null
            ? null
            : Employee.fromJson(json['employee'] as Map<String, dynamic>),
        reason: json['reason'] as String?,
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee': employee?.toJson(),
        'reason': reason,
        'status': status?.toJson(),
        'created_at': createdAt.toString(),
        'updated_at': updatedAt.toString(),
      };

  String? get updatedFormat {
    timeago.setLocaleMessages('id', IdMessages());
    return updatedAt == null ? null : timeago.format(updatedAt!, locale: 'id');
  }

  @override
  List<Object?> get props => [
        id,
        employee,
        reason,
        status,
        createdAt,
        updatedAt,
        updatedFormat,
      ];
}
