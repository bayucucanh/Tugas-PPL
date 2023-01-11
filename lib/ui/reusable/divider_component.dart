import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/constant/colors.dart';

class DividerComponent extends StatelessWidget {
  const DividerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
