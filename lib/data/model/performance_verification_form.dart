import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/performance_item.dart';
import 'package:mobile_pssi/data/model/performance_test.dart';

class PerformanceVerificationForm {
  int? performanceTestId;
  int? score;
  PerformanceItem? performanceItem;
  TextEditingController? actualScore;
  TextEditingController? realization;
  String? linkVideo;
  String? provider;

  PerformanceVerificationForm({
    this.actualScore,
    this.linkVideo,
    this.performanceTestId,
    this.score,
    this.performanceItem,
    this.realization,
    this.provider,
  });

  factory PerformanceVerificationForm.fromPerformanceTest(
          PerformanceTest performance) =>
      PerformanceVerificationForm(
        performanceTestId: performance.id,
        linkVideo: performance.linkUrl,
        performanceItem: performance.performanceItem,
        actualScore: TextEditingController(),
        realization: TextEditingController(),
        score: performance.score,
        provider: performance.provider,
      );

  Map<String, dynamic> toJson() => {
        'performance_test_id': performanceTestId,
        'actual_score': actualScore?.text,
        'realization': realization?.text,
      };
}
