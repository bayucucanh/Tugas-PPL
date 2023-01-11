import 'package:flutter/material.dart';
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';

class DatePicker {
  static Future<DateTime?>? getDate(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          primaryColor: primaryColor,
          backgroundColor: primaryColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
            backgroundColor: primaryColor,
          ),
          colorScheme: const ColorScheme.light(
            onPrimary: Colors.white,
            primary: primaryColor,
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: const TextStyle(
              color: primaryColor,
            ),
          )),
        ),
        child: child!,
      ),
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  static Future<DateTimeRange?>? getDateRange(
    BuildContext context,
  ) async {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: DateTime.now(),
      locale: const Locale.fromSubtags(languageCode: 'id'),
      builder: (context, widget) => Theme(
        data: Theme.of(context).copyWith(
            primaryColor: primaryColor,
            backgroundColor: primaryColor,
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: primaryColor,
            ),
            colorScheme: const ColorScheme.light(
              onPrimary: Colors.white,
              primary: primaryColor,
            )),
        child: widget!,
      ),
    );
  }

  static Future<void> getRangeTime(
    BuildContext context, {
    String title = 'Choose Event Time',
    TimeOfDay? initialFrom = const TimeOfDay(hour: 0, minute: 0),
    TimeOfDay? initialTo = const TimeOfDay(hour: 0, minute: 0),
    Function(TimeOfDay, TimeOfDay)? onSelect,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: TextButtonTheme(
                data: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
                child: TimeRangePicker(
                  initialFromHour: initialFrom?.hour,
                  initialFromMinutes: initialFrom?.minute,
                  initialToHour: initialTo?.hour,
                  initialToMinutes: initialTo?.minute,
                  backText: 'Kembali',
                  nextText: 'Lanjut',
                  cancelText: 'Batal',
                  selectText: 'Pilih',
                  editable: true,
                  activeLabelColor: primaryColor,
                  is24Format: true,
                  tabFromText: 'Dari',
                  tabToText: 'Sampai',
                  selectedTimeStyle: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  timeContainerStyle: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(10)),
                  disableTabInteraction: true,
                  separatorStyle:
                      TextStyle(color: Colors.grey[900], fontSize: 30),
                  onSelect: onSelect,
                  onCancel: () => Get.back(),
                ),
              ),
            ),
          );
        });
  }

  static Future<TimeOfDay?>? getTime(
    BuildContext context, {
    String? title,
  }) async {
    return showTimePicker(
      context: context,
      cancelText: 'Batal',
      confirmText: 'Pilih',
      hourLabelText: 'Jam',
      minuteLabelText: 'Menit',
      helpText: title,
      initialTime: const TimeOfDay(hour: 00, minute: 00),
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: true,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
              primaryColor: primaryColor,
              backgroundColor: primaryColor,
              appBarTheme: AppBarTheme.of(context).copyWith(
                backgroundColor: primaryColor,
              ),
              colorScheme: const ColorScheme.light(
                onPrimary: Colors.white,
                primary: primaryColor,
              )),
          child: widget!,
        ),
      ),
    );
  }
}
