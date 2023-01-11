import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/payment/controller/payment.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class Payment extends GetView<PaymentController> {
  static const routeName = '/payment';
  const Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      showAppBar: false,
      body: Obx(
        () => ZStack(
          [
            controller.progress.value < 1.0
                ? LinearProgressIndicator(value: controller.progress.value)
                : UiSpacer.emptySpace(),
            InAppWebView(
              onWebViewCreated: controller.onWebviewCreated,
              initialData: controller.getInitialData(),
              onProgressChanged: controller.onProgressChanged,
            ),
          ],
        ).safeArea(),
      ),
    );
  }
}
