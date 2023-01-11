import 'package:mobile_pssi/data/model/performance_category.dart';

class PerformanceItem {
  int? id;
  PerformanceCategory? performanceCategory;
  String? name;
  String? slug;
  String? inputType;
  int? minValue;
  int? maxValue;
  String? unitHint;
  int? status;

  PerformanceItem({
    this.id,
    this.inputType,
    this.name,
    this.performanceCategory,
    this.slug,
    this.status,
    this.minValue,
    this.maxValue,
    this.unitHint,
  });

  factory PerformanceItem.fromJson(Map<String, dynamic> json) =>
      PerformanceItem(
        id: json['id'] as int?,
        performanceCategory: json['performance_category'] == null
            ? null
            : PerformanceCategory.fromJson(
                json['performance_category'] as Map<String, dynamic>),
        name: json['name'] as String?,
        inputType: json['input_type'] as String?,
        minValue: json['min_value'] as int?,
        maxValue: json['max_value'] as int?,
        unitHint: json['score_unit_hint'] as String?,
        slug: json['slug'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'performance_category': performanceCategory?.toJson(),
        'name': name,
        'min_value': minValue,
        'max_value': maxValue,
        'score_unit_hint': unitHint,
        'slug': slug,
        'input_type': inputType,
        'status': status,
      };
}
