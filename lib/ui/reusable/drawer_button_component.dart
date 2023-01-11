import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/font.dart';

class DrawerButtonComponent extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String? routeName;
  final String label;

  const DrawerButtonComponent({
    Key? key,
    required this.label,
    required this.icon,
    this.routeName,
    this.onTap,
  }) : super(key: key);

  Color containerColor() {
    if (routeName != null) {
      return Colors.white;
    }

    if (Get.currentRoute == routeName) {
      return primaryColor;
    }
    return Colors.white;
  }

  Color iconColor() {
    if (routeName != null) {
      return primaryColor;
    }

    if (Get.currentRoute == routeName) {
      return Colors.white;
    }
    return primaryColor;
  }

  Color textColor() {
    if (routeName != null) {
      return Colors.black;
    }

    if (Get.currentRoute == routeName) {
      return Colors.white;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: primaryColor,
      splashColor: primaryColor,
      child: Container(
        color: containerColor(),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor(),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: textColor(),
              fontSize: h3,
            ),
          ),
        ),
      ),
    );
  }
}
