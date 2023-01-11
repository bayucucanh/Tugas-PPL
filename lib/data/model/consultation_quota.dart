import 'package:mobile_pssi/data/model/consultation_classification.dart';

class ConsultationQuota {
  int? id;
  DateTime? usedAt;
  ConsultationClassification? classification;

  ConsultationQuota({
    this.id,
    this.classification,
    this.usedAt,
  });

  factory ConsultationQuota.fromJson(Map<String, dynamic> json) =>
      ConsultationQuota(
        id: json['id'] as int?,
        usedAt:
            json['used_at'] == null ? null : DateTime.parse(json['used_at']),
        classification: json['classification'] == null
            ? null
            : ConsultationClassification.fromJson(
                json['classification'] as Map<String, dynamic>),
      );
}
