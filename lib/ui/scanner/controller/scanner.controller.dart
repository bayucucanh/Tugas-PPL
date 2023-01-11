import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/scanner.request.dart';
import 'package:mobile_pssi/ui/class/scanned_player_class.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends BaseController {
  final _scannerRequest = ScannerRequest();
  final MobileScannerController scannerController = MobileScannerController(
    autoResume: true,
    facing: CameraFacing.back,
    formats: [
      BarcodeFormat.qrCode,
    ],
    torchEnabled: false,
  );

  scanned(Barcode barcode, MobileScannerArguments? args) async {
    try {
      if (barcode.rawValue == null) {
        debugPrint('failed to scan barcode');
      } else {
        EasyLoading.show();
        final String code = barcode.rawValue!;
        await scannerController.stop();
        String? type = await _scannerRequest.getCodeType(code: code);
        EasyLoading.dismiss();
        if (type != null) {
          if (type == 'cv') {
            Get.back();
            Future.delayed(const Duration(milliseconds: 500), () async {
              await Get.toNamed(ScannedPlayerClass.routeName, arguments: code);
            });
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      await scannerController.start();
      getSnackbar('Informasi', e.toString());
    }
  }

  back() {
    Get.back(closeOverlays: true, canPop: true);
  }

  changeCamera() {
    scannerController.switchCamera();
  }

  enableTorch() {
    scannerController.toggleTorch();
  }
}
