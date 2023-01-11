import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/utils/date_picker.dart';

class NewSelectionFormController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final location = TextEditingController();
  final address = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  final birthYears = TextEditingController();
  final competition = TextEditingController();
  final passQuota = TextEditingController();
  final selectionFee = TextEditingController();
  final notes = TextEditingController();
  final fee = TextEditingController();
  final formQuota = TextEditingController();
  final _df = DateFormat('dd/MM/yyyy');
  final _fj = DateFormat('yyyy-MM-dd');
  final _ttf = DateFormat.Hm();
  final _tf = DateFormat.Hm();
  final _defaultTime = const TimeOfDay(hour: 0, minute: 0);

  selectRangeDate(
    BuildContext context,
  ) async {
    DateTimeRange? dateRange = await DatePicker.getDateRange(context);
    if (dateRange != null) {
      startDate.text = _df.format(dateRange.start);
      endDate.text = _df.format(dateRange.end);
      Get.focusScope?.unfocus();
    }
  }

  selectTimeRange(BuildContext context) async {
    TimeOfDay? initialFrom = fromFormat == null
        ? _defaultTime
        : TimeOfDay(hour: fromFormat!.hour, minute: fromFormat!.minute);
    TimeOfDay? initialTo = toFormat == null
        ? _defaultTime
        : TimeOfDay(hour: toFormat!.hour, minute: toFormat!.minute);

    await DatePicker.getRangeTime(
      context,
      title: 'Pilih Waktu',
      initialFrom: initialFrom,
      initialTo: initialTo,
      onSelect: (TimeOfDay from, TimeOfDay to) {
        startTime.text = _ttf.format(_tf.parse(from.format(context)));
        endTime.text = _ttf.format(_tf.parse(to.format(context)));
        Get.back();
      },
    );
  }

  toJson() => {
        'location': location.text,
        'address': address.text,
        'start_date': _fj.format(_df.parse(startDate.text)),
        'end_date': _fj.format(_df.parse(endDate.text)),
        'start_time': startTime.text,
        'end_time': endTime.text,
        'birth_years': birthYears.text,
        'competition': competition.text,
        'pass_quota': passQuota.text,
        'selection_fee': selectionFee.text.isBlank == true
            ? null
            : _currencyFormatter.format(selectionFee.text),
        'notes': notes.text,
        'fee': _currencyFormatter.format(fee.text),
        'form_quota': formQuota.text,
      };

  DateTime? get fromFormat =>
      startTime.text.isEmpty == true ? null : _tf.parse(startTime.text);
  DateTime? get toFormat =>
      endTime.text.isEmpty == true ? null : _tf.parse(endTime.text);
}
