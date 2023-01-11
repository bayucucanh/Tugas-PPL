import 'package:mobile_pssi/data/model/consultation_classification.dart';
import 'package:mobile_pssi/data/model/consultation_schedule.dart';
import 'package:mobile_pssi/data/model/user.dart';

class ConsultationClassificationUser {
  int? id;
  User? user;
  ConsultationClassification? classification;
  List<ConsultationSchedule>? schedules;
  ConsultationSchedule? todaySchedule;
  bool? status;
  int? totalConsultation;
  ConsultationClassification? nextLevel;
  double? incomes;

  ConsultationClassificationUser({
    this.id,
    this.classification,
    this.user,
    this.status,
    this.totalConsultation,
    this.schedules,
    this.todaySchedule,
    this.nextLevel,
    this.incomes,
  });

  factory ConsultationClassificationUser.fromJson(Map<String, dynamic> json) {
    return ConsultationClassificationUser(
      id: json['id'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      classification: json['consultation_classification'] == null
          ? null
          : ConsultationClassification.fromJson(
              json['consultation_classification'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => ConsultationSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      todaySchedule: json['today_schedule'] == null
          ? null
          : ConsultationSchedule.fromJson(
              json['today_schedule'] as Map<String, dynamic>),
      status: json['status'] == 1 ? true : false,
    );
  }

  factory ConsultationClassificationUser.fromJsonWithLevel(
      Map<String, dynamic> data) {
    Map<String, dynamic> json = data['data'];
    int? totalConsultation = data['total_consultation'] as int?;
    Map<String, dynamic>? nextLevel = data['next_level'];
    return ConsultationClassificationUser(
      id: json['id'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      classification: json['consultation_classification'] == null
          ? null
          : ConsultationClassification.fromJson(
              json['consultation_classification'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => ConsultationSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      incomes: data['incomes'] == null
          ? null
          : double.parse(data['incomes'].toString()),
      status: json['status'] == 1 ? true : false,
      nextLevel: nextLevel == null
          ? null
          : ConsultationClassification.fromJson(nextLevel),
      totalConsultation: totalConsultation,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'consultation_classification': classification?.toJson(),
        'today_schedule': todaySchedule?.toJson(),
        'schedules': schedules?.map((e) => e.toJson()),
        'status': status,
      };

  double get progressLevelUp {
    if (totalConsultation == null) {
      return 0;
    }

    if (totalConsultation! <= 0) {
      return 0;
    }
    return totalConsultation! /
        (nextLevel == null ? totalConsultation : nextLevel!.passingGrade!)!;
  }

  int get consultationLeftToLevelUp {
    if (totalConsultation == null) {
      return 0;
    }

    if (totalConsultation! <= 0) {
      return 0;
    }
    if (nextLevel == null) {
      return totalConsultation!;
    }
    return nextLevel!.passingGrade! - totalConsultation!;
  }
}
