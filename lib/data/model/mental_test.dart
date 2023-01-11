import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/scat_question.dart';

class MentalTest {
  int? id;
  PerformanceTestVerification? performanceTestVerification;
  ScatQuestion? scatQuestion;
  int? scoreScat;

  MentalTest({
    this.id,
    this.performanceTestVerification,
    this.scatQuestion,
    this.scoreScat,
  });

  factory MentalTest.fromJson(Map<String, dynamic> json) => MentalTest(
        id: json['id'] as int?,
        performanceTestVerification: json['performance_test_verification'] ==
                null
            ? null
            : PerformanceTestVerification.fromJson(
                json['performance_test_verification'] as Map<String, dynamic>),
        scatQuestion: json['scat_question'] == null
            ? null
            : ScatQuestion.fromJson(
                json['scat_question'] as Map<String, dynamic>),
        scoreScat: json['score_scat'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'performance_test_verification': performanceTestVerification?.toJson(),
        'scat_question': scatQuestion?.toJson(),
        'score_scat': scoreScat,
      };
}
