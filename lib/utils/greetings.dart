import 'package:flutter/material.dart';

String greetings() {
  TimeOfDay now = TimeOfDay.now();
  if (now.hour >= 6 && now.hour < 10) {
    return "Pagi";
  } else if (now.hour >= 10 && now.hour < 15) {
    return "Siang";
  } else if (now.hour >= 15 && now.hour < 18) {
    return "Sore";
  } else if (now.hour >= 18 && now.hour <= 23) {
    return "Malam";
  } else {
    return "Dini Hari";
  }
}
