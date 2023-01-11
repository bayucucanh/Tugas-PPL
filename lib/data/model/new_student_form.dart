import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:mobile_pssi/data/model/new_student_additional_field.dart';
import 'package:mobile_pssi/data/model/practice_schedule.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/village.dart';

class NewStudentForm {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  Promotion? promotion;
  String? practiceLocation;
  String? address;
  Village? village;
  String? notes;
  double? startUpFee;
  double? monthlyFee;
  List<PracticeSchedule>? schedules;
  List<NewStudentAdditionalField>? additionalFields;

  NewStudentForm({
    this.id,
    this.promotion,
    this.additionalFields,
    this.address,
    this.monthlyFee,
    this.notes,
    this.practiceLocation,
    this.schedules,
    this.startUpFee,
    this.village,
  });

  factory NewStudentForm.fromJson(Map<String, dynamic> json) => NewStudentForm(
        id: json['id'] as int?,
        address: json['address'] as String?,
        notes: json['notes'] as String?,
        promotion: json['promotion'] == null
            ? null
            : Promotion.fromJson(json['promotion'] as Map<String, dynamic>),
        practiceLocation: json['practice_location'] as String?,
        village: json['village'] == null
            ? null
            : Village.fromJson(json['village'] as Map<String, dynamic>),
        monthlyFee: json['monthly_fee'] == null
            ? null
            : double.tryParse(json['monthly_fee'].toString()),
        startUpFee: json['start_up_fee'] == null
            ? null
            : double.tryParse(json['start_up_fee'].toString()),
        schedules: (json['practice_schedules'] as List<dynamic>?)
            ?.map((e) => PracticeSchedule.fromJson(e as Map<String, dynamic>))
            .toList(),
        additionalFields: (json['additional_fields'] as List<dynamic>?)
            ?.map((e) =>
                NewStudentAdditionalField.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'notes': notes,
        'promotion': promotion?.toJson(),
        'practice_location': practiceLocation,
        'village': village?.toJson(),
        'monthly_fee': monthlyFee,
        'start_up_fee': startUpFee,
        'practice_schedules': schedules?.map((e) => e.toJson()).toList(),
        'additional_fields': additionalFields?.map((e) => e.toJson()).toList()
      };

  String? get startUpFeePrice => startUpFee == null
      ? null
      : _currencyFormatter.format(startUpFee.toString());

  String? get monthlyFeePrice => monthlyFee == null
      ? null
      : _currencyFormatter.format(monthlyFee.toString());
}
