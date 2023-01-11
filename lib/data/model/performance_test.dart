import 'package:mobile_pssi/data/model/performance_item.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';

class PerformanceTest {
  int? id;
  PerformanceTestVerification? performanceTestVerification;
  PerformanceItem? performanceItem;
  int? score;
  int? actualScore;
  String? linkUrl;
  String? provider;

  PerformanceTest({
    this.id,
    this.actualScore,
    this.linkUrl,
    this.performanceItem,
    this.performanceTestVerification,
    this.score,
    this.provider,
  });

  factory PerformanceTest.fromJson(Map<String, dynamic> json) =>
      PerformanceTest(
        id: json['id'] as int?,
        performanceTestVerification: json['performance_test_verification'] ==
                null
            ? null
            : PerformanceTestVerification.fromJson(
                json['performance_test_verification'] as Map<String, dynamic>),
        performanceItem: json['performance_item'] == null
            ? null
            : PerformanceItem.fromJson(
                json['performance_item'] as Map<String, dynamic>),
        score: json['score'] as int?,
        actualScore: json['actual_score'] as int?,
        linkUrl: json['link_url'] as String?,
        provider: json['provider'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'performance_test_verification': performanceTestVerification?.toJson(),
        'performance_item': performanceItem?.toJson(),
        'score': score,
        'actual_score': actualScore,
        'link_url': linkUrl,
        'provider': provider,
      };
}
