import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/secure_document.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/document.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:path/path.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDocumentsController extends BaseController {
  final refreshController = RefreshController();
  final _documentRequest = DocumentRequest();
  final _user = User().obs;
  final _documents = Resource<List<SecureDocument>>(data: []).obs;
  final _page = 1.obs;

  UserDocumentsController() {
    _user(User.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchDocuments();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _documents.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchDocuments();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDocuments() async {
    try {
      EasyLoading.show();
      var resp = await _documentRequest.getUserDocuments(
          userId: _user.value.id!, page: _page.value);
      _documents.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (_page.value >= _documents.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchDocuments();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDialog(SecureDocument? document) async {
    if (document?.file == null) {
      getDialog(ConfirmationDefaultDialog(
        title: (document?.name ?? '-'),
        confirmText: 'Tolak',
        cancelText: 'Batal',
        content: 'File dokumen tidak tersedia.',
        onConfirm: () => _updateStatus(document!, 2),
      ));
    } else {
      String ext = extension(document!.file!);
      Future.delayed(const Duration(milliseconds: 500), () {
        getDialog(
          ConfirmationDefaultDialog(
            title: (document.name ?? '-'),
            confirmText: 'Verifikasi',
            cancelText: 'Tolak',
            contentWidget: VStack([
              if (document.slug == 'ktp')
                'NIK : ${document.user?.employee?.nik ?? 'Belum input NIK'}'
                    .text
                    .make(),
              UiSpacer.verticalSpace(space: 10),
              ext == '.pdf'
                  ? PdfViewPinch(
                          onDocumentError: (error) =>
                              'Tidak dapat membuka file pdf.',
                          controller: PdfControllerPinch(
                              document: PdfDocument.openData(
                                  _getDocumentFile(document))))
                      .box
                      .withConstraints(const BoxConstraints(
                        minHeight: 100,
                        maxHeight: 400,
                      ))
                      .make()
                  : CachedNetworkImage(
                      imageUrl: document.file!,
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                        value: progress.progress,
                        color: primaryColor,
                      ).centered(),
                    )
                      .box
                      .withConstraints(const BoxConstraints(
                        minHeight: 100,
                        maxHeight: 400,
                      ))
                      .makeCentered(),
            ]),
            onConfirm: () => _updateStatus(document, 1),
            onCancel: () => _updateStatus(document, 2),
          ),
        );
      });
    }
  }

  _updateStatus(SecureDocument document, int status) async {
    try {
      EasyLoading.show();
      await _documentRequest.updateStatus(
          documentId: document.id!, status: status);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  FutureOr<Uint8List> _getDocumentFile(SecureDocument document) async {
    return InternetFile.get(document.file!);
  }

  User? get user => _user.value;
  List<SecureDocument>? get documents => _documents.value.data;
}
