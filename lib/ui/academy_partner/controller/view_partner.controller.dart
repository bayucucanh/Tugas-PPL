import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/model/consultation_classification_user.dart';
import 'package:mobile_pssi/data/model/secure_document.dart';
import 'package:mobile_pssi/data/requests/document.request.dart';
import 'package:mobile_pssi/data/requests/partner.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:path/path.dart';
import 'package:pdfx/pdfx.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewPartnerController extends BaseController {
  final _partnerRequest = PartnerRequest();
  final _documentRequest = DocumentRequest();
  final _partner = const AcademyPartner().obs;
  final reason = TextEditingController();
  final _activeConsultant = false.obs;
  final _activeContentCreator = false.obs;

  ViewPartnerController() {
    _partner(AcademyPartner.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() async {
    await _fetchPartner();
    await _checkContentCreator();
    await _checkConsultant();
  }

  _fetchPartner() async {
    try {
      EasyLoading.show();
      _partner.update((val) async {
        val = await _partnerRequest.detail(id: _partner.value.id!);
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openDialog(SecureDocument? document) async {
    String ext = extension(document!.file!);
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.dialog(
        ConfirmationDefaultDialog(
          title: (document.name ?? '-'),
          confirmText: 'Verifikasi',
          cancelText: 'Tolak',
          contentWidget: ext == '.pdf'
              ? PdfViewPinch(
                      controller: PdfControllerPinch(
                          document:
                              PdfDocument.openData(_getDocumentFile(document))))
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
          onConfirm: () => _updateStatus(document, 1),
          onCancel: () => _updateStatus(document, 2),
          showCancel: document.status?.id == 1 ? false : true,
          showConfirm: document.status?.id == 1 ? false : true,
        ),
      );
    });
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
      _fetchPartner();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  verifyDialog(int status) {
    if (status == 1) {
      getDialog(ConfirmationDefaultDialog(
        title: 'Verifikasi Partner',
        cancelText: 'Batal',
        content: 'Apakah benar anda akan memverifikasi partner ini?',
        onConfirm: () => _verifyPartner(status),
      ));
    } else {
      getDialog(ConfirmationDefaultDialog(
        title: 'Tolak Partner',
        cancelText: 'Batal',
        content: 'Apakah benar anda akan menolak partner ini?',
        onConfirm: () => _verifyPartner(status),
      ));
    }
  }

  _verifyPartner(int status) async {
    try {
      EasyLoading.show();
      await _partnerRequest.verify(
          partnerId: _partner.value.id!, status: status, reason: reason.text);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _fetchPartner();
      reason.clear();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _checkConsultant() {
    ConsultationClassificationUser? classificationUser =
        _partner.value.employee?.user?.classificationUser;
    if (classificationUser == null) {
      _activeConsultant(false);
    } else {
      _activeConsultant(classificationUser.status);
    }
  }

  _checkContentCreator() {
    if (_partner.value.employee!.user!.hasRole('Course Creator')) {
      _activeContentCreator(true);
    } else {
      _activeContentCreator(false);
    }
  }

  toggleConsultant(bool? value) async {
    try {
      EasyLoading.show();
      await _partnerRequest.activeConsultation(
          partnerId: _partner.value.id!, status: value!);
      EasyLoading.dismiss();
      _activeConsultant.toggle();
    } catch (e) {
      _activeConsultant(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  toggleContentCreator(bool? value) async {
    try {
      EasyLoading.show();
      await _partnerRequest.activeContentCreator(partnerId: _partner.value.id!);
      EasyLoading.dismiss();
      _activeContentCreator.toggle();
    } catch (e) {
      _activeContentCreator(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  FutureOr<Uint8List> _getDocumentFile(SecureDocument document) async {
    return InternetFile.get(document.file!);
  }

  bool get activeConsultant => _activeConsultant.value;
  bool get activeContentCreator => _activeContentCreator.value;
  AcademyPartner? get partner => _partner.value;
}
