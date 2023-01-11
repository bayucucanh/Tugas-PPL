import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/coach_offering_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/offer_by.dart';
import 'package:mobile_pssi/data/model/status.dart';

class CoachOffering {
  int? id;
  Club? club;
  Employee? employee;
  OfferBy? offerBy;
  Status? status;
  List<CoachOfferingPosition>? offeringPositions;
  String? offerText;
  String? offerFile;

  CoachOffering({
    this.id,
    this.club,
    this.employee,
    this.offerBy,
    this.status,
    this.offeringPositions,
    this.offerFile,
    this.offerText,
  });

  factory CoachOffering.fromJson(Map<String, dynamic> json) {
    return CoachOffering(
      id: json['id'] as int?,
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
      offerBy: json['offer_by'] == null
          ? null
          : OfferBy.fromJson(json['offer_by'] as Map<String, dynamic>),
      offeringPositions: (json['positions'] as List<dynamic>?)
          ?.map(
              (e) => CoachOfferingPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] == null
          ? null
          : json['status'] is Map
              ? Status.fromJson(json['status'] as Map<String, dynamic>)
              : null,
      offerText: json['offer_text'] as String?,
      offerFile: json['offer_file'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club?.toJson(),
        'employee': employee?.toJson(),
        'offer_by': offerBy?.toJson(),
        'positions': offeringPositions?.map((e) => e.toJson()).toList(),
        'status': status?.toJson(),
        'offer_text': offerText,
        'offer_file': offerFile,
      };

  Color get statusColor {
    Color defaultColor = Colors.grey;
    if (status?.id == 1) {
      defaultColor = Colors.green;
    } else if (status?.id == 2) {
      defaultColor = Colors.red;
    }
    return defaultColor;
  }
}
