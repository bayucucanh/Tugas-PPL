import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class ConsultationClassification {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  String? name;
  String? slug;
  int? passingGrade;
  int? pricing;

  ConsultationClassification({
    this.id,
    this.name,
    this.passingGrade,
    this.pricing,
    this.slug,
  });

  factory ConsultationClassification.fromJson(Map<String, dynamic> json) {
    return ConsultationClassification(
      id: json['id'] as int?,
      name: json['name'] as String?,
      passingGrade: json['passing_grade'] as int?,
      pricing: json['pricing'] as int?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'passing_grade': passingGrade,
        'pricing': pricing,
      };

  String? get priceFormat =>
      pricing == null ? null : _currencyFormatter.format(pricing.toString());

  String? get priceWithTax {
    if (pricing == null) {
      return null;
    }
    double tax = 11 / 100;
    double totalTax = pricing! * tax;
    double totalPrice = pricing! + totalTax;
    return _currencyFormatter.format(totalPrice.toStringAsFixed(0));
  }
}
