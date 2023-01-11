import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/coach_offering_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/offer_by.dart';
import 'package:mobile_pssi/data/model/status.dart';

class ClubCoachOffering {
  int? id;
  Club? clubReference;
  Club? club;
  Employee? employee;
  OfferBy? offerBy;
  Status? status;
  List<CoachOfferingPosition>? offeringPositions;
  String? offerText;
  String? offerFile;
  String? replyFile;

  ClubCoachOffering({
    this.id,
    this.clubReference,
    this.club,
    this.employee,
    this.offerBy,
    this.status,
    this.offeringPositions,
    this.offerFile,
    this.offerText,
    this.replyFile,
  });

  factory ClubCoachOffering.fromJson(Map<String, dynamic> json) {
    return ClubCoachOffering(
      id: json['id'] as int?,
      clubReference: json['club_reference'] == null
          ? null
          : Club.fromJson(json['club_reference'] as Map<String, dynamic>),
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
      replyFile: json['reply_file'] as String?,
    );
  }

  Color get statusColor {
    Color defaultColor = Colors.grey;
    switch (status?.id) {
      case 1:
        defaultColor = Colors.blue;
        break;
      case 2:
        defaultColor = Colors.red;
        break;
      case 3:
        defaultColor = Colors.green;
        break;
    }
    return defaultColor;
  }
}
