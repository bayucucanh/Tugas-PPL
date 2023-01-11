import 'package:mobile_pssi/utils/numeral/numeral.dart';

extension NumeralExtension on num {
  String numeral({int fractionDigits = 3}) {
    return Numeral(this).format(fractionDigits: fractionDigits);
  }
}
