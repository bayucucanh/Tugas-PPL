import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';

extension TestParameterColor on int {
  Color? getNumberColor() {
    Color color = Colors.black;
    if (this >= 70 && this <= 79) {
      color = Colors.yellow.shade800;
    } else if (this >= 80 && this <= 88) {
      color = Colors.green;
    } else if (this >= 89) {
      color = primaryColor;
    }
    return color;
  }
}
