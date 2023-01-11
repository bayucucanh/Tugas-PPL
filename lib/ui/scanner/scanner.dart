import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/scanner/controller/scanner.controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

class Scanner extends GetView<ScannerController> {
  static const routeName = '/scanner';
  const Scanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ScannerController());
    return DefaultScaffold(
      showAppBar: false,
      backgroundColor: Get.theme.backgroundColor,
      body: ZStack([
        MobileScanner(
          onDetect: controller.scanned,
          allowDuplicates: false,
          controller: controller.scannerController,
        ),
        HStack(
          [
            VStack(
              [
                const Icon(
                  FontAwesomeIcons.angleLeft,
                  color: Vx.white,
                ),
                'Kembali'.text.sm.white.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).onInkTap(controller.back),
            VStack(
              [
                const Icon(
                  FontAwesomeIcons.cameraRotate,
                  color: Vx.white,
                ),
                'Ubah Kamera'.text.sm.white.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).onInkTap(controller.changeCamera),
            VStack(
              [
                const Icon(
                  FontAwesomeIcons.lightbulb,
                  color: Vx.white,
                ),
                'Nyalakan Cahaya'.text.sm.white.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).onInkTap(controller.enableTorch),
          ],
          axisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.spaceAround,
          crossAlignment: CrossAxisAlignment.center,
        )
            .box
            .p12
            .color(primaryColor)
            .roundedLg
            .make()
            .wFull(context)
            .p12()
            .positioned(bottom: 20, left: 10, right: 10),
      ]).safeArea(),
    );
  }
}
