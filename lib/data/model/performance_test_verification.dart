import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/mental_test.dart';
import 'package:mobile_pssi/data/model/performance_test.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/recommended.dart';
import 'package:mobile_pssi/data/model/status.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago_flutter/timeago_flutter.dart';

class PerformanceTestVerification {
  int? id;
  Player? player;
  Employee? employee;
  int? scatScore;
  Recommended? recommended;
  List<PerformanceTest>? performanceTests;
  List<MentalTest>? mentalTests;
  String? reason;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  PerformanceTestVerification({
    this.id,
    this.createdAt,
    this.employee,
    this.player,
    this.reason,
    this.recommended,
    this.scatScore,
    this.status,
    this.performanceTests,
    this.mentalTests,
    this.updatedAt,
  });

  factory PerformanceTestVerification.fromJson(Map<String, dynamic> json) {
    return PerformanceTestVerification(
      id: json['id'] as int?,
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
      scatScore: json['scat_score'] as int?,
      recommended: json['recommended'] == null
          ? null
          : Recommended.fromJson(json['recommended'] as Map<String, dynamic>),
      reason: json['reason'] as String?,
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      performanceTests: (json['performance_tests'] as List<dynamic>?)
          ?.map((e) => PerformanceTest.fromJson(e as Map<String, dynamic>))
          .toList(),
      mentalTests: (json['mental_tests'] as List<dynamic>?)
          ?.map((e) => MentalTest.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'].toString()).toLocal(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'player': player?.toJson(),
        'employee': employee?.toJson(),
        'scat_score': scatScore,
        'recommended': recommended?.toJson(),
        'performance_tests': performanceTests?.map((e) => e.toJson()).toList(),
        'mental_tests': mentalTests?.map((e) => e.toJson()).toList(),
        'reason': reason,
        'status': status?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  String get formatCreatedAt => createdAt == null
      ? '-'
      : DateFormat('dd MMMM yyyy', 'id_ID').format(createdAt!);

  String get formatUpdated => updatedAt == null
      ? '-'
      : DateFormat('dd MMMM yyyy', 'id_ID').format(updatedAt!);

  String? get anxietyDescription {
    if (scatScore == null) {
      return null;
    }
    if (scatScore! <= 52) {
      return 'High Level Anxiety';
    } else if (scatScore! >= 53 && scatScore! <= 68) {
      return 'Average Level Anxiety';
    } else {
      return 'Low Level Anxiety';
    }
  }

  String? get overallRating {
    if (performanceTests == null) {
      return null;
    }

    double? result = calculateScore(performanceTests);

    return formatResult(result, performanceTests);
  }

  String? get totalTechnique {
    if (performanceTests == null) {
      return null;
    }

    List<PerformanceTest>? performances =
        getPerformanceVerificationByCategoryId(1);

    double? result = calculateScore(performances);

    return formatResult(result, performances, useFixed: true);
  }

  String? get totalPhsyique {
    if (performanceTests == null) {
      return null;
    }

    List<PerformanceTest>? performances =
        getPerformanceVerificationByCategoryId(2);

    double? result = calculateScore(performances);

    return formatResult(result, performances, useFixed: true);
  }

  String? get totalAttack {
    if (performanceTests == null) {
      return null;
    }

    List<PerformanceTest>? performances =
        getPerformanceVerificationByCategoryId(3);

    double? result = calculateScore(performances);

    return formatResult(result, performances, useFixed: true);
  }

  String? get totalDefend {
    if (performanceTests == null) {
      return null;
    }

    List<PerformanceTest>? performances =
        getPerformanceVerificationByCategoryId(4);

    double? result = calculateScore(performances);

    return formatResult(result, performances, useFixed: true);
  }

  String? get totalScatScore {
    if (mentalTests == null) {
      return null;
    }

    double? result = mentalTests?.fold(0, (previousValue, element) {
      if (element.scoreScat != null) {
        return previousValue! + element.scoreScat!;
      } else {
        return previousValue;
      }
    });
    return result?.toStringAsFixed(0);
  }

  double? get avgResults {
    double? totalScore;
    if (overallRating != null && scatScore != null) {
      totalScore =
          (double.parse(overallRating!) + double.parse(scatScore.toString())) /
              2;
    }
    return totalScore;
  }

  String? formatResult(double? result, List<PerformanceTest>? data,
      {bool useFixed = false}) {
    if (result != null) {
      if (result > 1) {
        double? total = result / data!.length;
        return useFixed == true ? total.toStringAsFixed(0) : total.toString();
      }
    }
    return useFixed == true ? result?.toStringAsFixed(0) : result.toString();
  }

  double? calculateScore(List<PerformanceTest>? data) {
    return data?.fold(0, (previousValue, element) {
      if (element.actualScore != null) {
        return previousValue! + element.actualScore!;
      } else {
        return previousValue;
      }
    });
  }

  List<PerformanceTest>? getPerformanceVerificationByCategoryId(int id) {
    if (performanceTests == null || performanceTests!.isEmpty) {
      return [];
    }
    return performanceTests
        ?.where((performanceTest) =>
            performanceTest.performanceItem?.performanceCategory?.id == id)
        .map((e) => e)
        .toList();
  }

  Color? get scoreColor {
    Color color = Colors.black;
    if (avgResults != null) {
      if (avgResults! >= 70 && avgResults! <= 79) {
        color = Colors.yellow;
      } else if (avgResults! >= 80 && avgResults! <= 88) {
        color = Colors.green;
      } else if (avgResults! >= 89) {
        color = primaryColor;
      }
    }
    return color;
  }

  String? get moment {
    timeago.setLocaleMessages('id', IdMessages());
    return createdAt == null ? null : timeago.format(createdAt!, locale: 'id');
  }
}
