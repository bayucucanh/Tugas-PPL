import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:mobile_pssi/data/model/new_student_form.dart';

class NewStudentAdditionalField {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  NewStudentForm? newStudentForm;
  String? name;
  double? value;

  NewStudentAdditionalField({
    this.id,
    this.name,
    this.newStudentForm,
    this.value,
  });

  factory NewStudentAdditionalField.fromJson(Map<String, dynamic> json) =>
      NewStudentAdditionalField(
        id: json['id'] as int?,
        name: json['name'] as String?,
        value: json['value'] == null
            ? null
            : double.tryParse(json['value'].toString()),
        newStudentForm: json['new_student_form'] == null
            ? null
            : NewStudentForm.fromJson(
                json['new_student_form'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
        'new_student_form': newStudentForm?.toJson(),
      };

  String? get valuePrice =>
      value == null ? null : _currencyFormatter.format(value.toString());
}
