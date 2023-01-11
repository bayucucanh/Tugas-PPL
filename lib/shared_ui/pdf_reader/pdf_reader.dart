import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/controller/pdf_reader.controller.dart';
import 'package:pdfx/pdfx.dart';

class PdfReader extends GetView<PdfReaderController> {
  static const routeName = '/view/document';
  const PdfReader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PdfReaderController());
    return DefaultScaffold(
      showAppBar: true,
      backgroundColor: Get.theme.backgroundColor,
      actions: [
        if (controller.hasDownload.value)
          IconButton(
            onPressed: controller.downloadFile,
            icon: const Icon(Icons.download),
            tooltip: 'Download',
          ),
      ],
      body: PdfViewPinch(
        controller: controller.pdfPinchController!,
      ),
    );
  }
}
