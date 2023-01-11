import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T> getDialog<T>(Widget widget, {bool barrierDismissible = true}) async {
  return await Get.dialog(widget, barrierDismissible: barrierDismissible);
}

Future<T> getBottomSheet<T>(
  Widget bottomSheet, {
  bool isScrollControlled = false,
  bool enableDrag = true,
  bool isDismissible = true,
}) async {
  return await Get.bottomSheet(
    bottomSheet,
    backgroundColor: Get.theme.backgroundColor,
    isScrollControlled: isScrollControlled,
    ignoreSafeArea: false,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  );
}

getSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Get.theme.backgroundColor,
  );
}
