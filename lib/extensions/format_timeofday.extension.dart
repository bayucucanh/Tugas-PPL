import 'package:flutter/material.dart';

extension FormatTimeOfDayExtension on TimeOfDay {
  String formatTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
