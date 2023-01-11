import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';

class ReviewClassController extends BaseController {
  final rating = 5.0.obs;
  final description = TextEditingController();

  changeRating(double updateRate) {
    rating(updateRate);
  }

  resetDefault() {
    rating(5.0);
    description.clear();
  }
}
