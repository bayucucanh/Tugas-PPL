import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfReaderController extends BaseController {
  late PdfControllerPinch? pdfPinchController;
  final pdfLink = ''.obs;
  final hasDownload = false.obs;
  final isDownloading = false.obs;
  final progress = 0.0.obs;
  final linkDownload = ''.obs;
  final filename = ''.obs;

  PdfReaderController() {
    pdfLink(Get.arguments);
    if (Get.parameters['link'] != null) {
      hasDownload(true);
      linkDownload(Get.parameters['link']);
      filename(Get.parameters['filename']);
    }
  }

  @override
  void onInit() {
    openingPdf();
    super.onInit();
  }

  @override
  void onClose() {
    pdfPinchController?.dispose();
    super.onClose();
  }

  openingPdf() {
    pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openData(InternetFile.get(pdfLink.value)),
    );
  }

  downloadFile() async {
    if (filename.isEmpty) {
      getSnackbar('Informasi', 'Nama file tidak diketahui.');
      return;
    }
    bool canDownload = false;
    if (await Permission.storage.request() == PermissionStatus.granted) {
      canDownload = true;
    }
    Directory dir;
    if (GetPlatform.isAndroid) {
      // dir = (await getExternalStorageDirectories(
      //         type: StorageDirectory.documents))!
      //     .first;
      dir = Directory('/storage/emulated/0/Download');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    String? path = await FilesystemPicker.openDialog(
      context: Get.context!,
      rootDirectory: dir,
      title: 'Simpan CV',
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      fsType: FilesystemType.folder,
      rootName: 'Download',
      pickText: 'Pilih Folder Ini Untuk Menyimpan',
      permissionText: 'Akses ke storage tidak diizinkan.',
      requestPermission: () async {
        return await Permission.storage.request() == PermissionStatus.granted;
      },
      showGoUp: true,
    );
    if (path != null) {
      if (canDownload) {
        try {
          EasyLoading.show();
          await network.download(linkDownload.value,
              filename: filename.value, folderPath: path,
              onReceive: (int? receivedByte, int? totalBytes) {
            isDownloading(true);
          });
        } catch (e) {
          EasyLoading.dismiss();
          isDownloading(false);
          getSnackbar('Informasi', e.toString());
        }
        isDownloading(false);
        if (isDownloading.value == false) {
          EasyLoading.dismiss();
          getSnackbar(
              'Informasi', 'Berhasil mengunduh file ke dalam folder Download.');
        }
      } else {
        getSnackbar('Informasi',
            'Permisi untuk akses folder download tidak diberikan.');
      }
    }
  }
}
