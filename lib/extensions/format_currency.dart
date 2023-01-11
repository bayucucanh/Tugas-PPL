import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

extension FormatCurrency on double {
  static final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  String? toCurrency() {
    return _currencyFormatter.format(toStringAsFixed(0));
  }
}
