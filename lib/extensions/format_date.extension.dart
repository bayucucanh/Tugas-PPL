import 'package:intl/intl.dart';

extension FormatDateExtension on DateTime {
  String? toFormattedDate() {
    return DateFormat('dd MMMM yyyy HH:mm:ss', 'id_ID').format(this);
  }
}
