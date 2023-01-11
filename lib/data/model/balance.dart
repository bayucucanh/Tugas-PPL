import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class Balance {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  double balance;

  Balance({this.balance = 0.0});

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
      balance: json['balance'] == null
          ? 0.0
          : double.parse(json['balance'].toString()));

  String get balanceFormat =>
      _currencyFormatter.format(balance.toStringAsFixed(0));
}
