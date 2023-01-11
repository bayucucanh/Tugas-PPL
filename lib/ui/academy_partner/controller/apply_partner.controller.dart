import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/requests/partner.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ApplyPartnerController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final licenseTx = TextEditingController();
  final license = FileObservable().obs;
  final certificateTx = TextEditingController();
  final certificate = FileObservable().obs;
  final _partnerRequest = PartnerRequest();
  final _isUploading = false.obs;
  final _agreement = false.obs;
  final _partnerStatus = const AcademyPartner().obs;

  @override
  void onInit() {
    checkApplyStatus();
    super.onInit();
  }

  pickLicense() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
      type: FileType.custom,
      dialogTitle: 'Pilih Lisensi Kepelatihan',
    );
    if (result != null) {
      license(FileObservable.filePickerResult(result));
      licenseTx.text = license.value.name ?? '';
    }
  }

  pickCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
      type: FileType.custom,
      dialogTitle: 'Pilih Sertifikat Konsultan',
    );
    if (result != null) {
      certificate(FileObservable.filePickerResult(result));
      certificateTx.text = certificate.value.name ?? '';
    }
  }

  toggleAgreement(bool? value) {
    _agreement.toggle();
  }

  applyPartner() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        _isUploading(true);
        FormData data = FormData.fromMap({
          'certificate_consultant': certificate.value.path == null
              ? null
              : await MultipartFile.fromFile(certificate.value.path!,
                  filename: certificate.value.name),
          'coach_license': license.value.path == null
              ? null
              : await MultipartFile.fromFile(license.value.path!,
                  filename: license.value.name),
        });
        await _partnerRequest.applyPartner(data: data);
        _isUploading(false);
        checkApplyStatus();
        EasyLoading.dismiss();
        getSnackbar('Informasi', 'Berhasil mengajukan permintaan partner.');
      }
    } catch (e) {
      _isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  checkApplyStatus() async {
    try {
      EasyLoading.show();
      AcademyPartner? partner = await _partnerRequest.checkPartner();
      EasyLoading.dismiss();
      _partnerStatus(partner);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  bool get isUploading => _isUploading.value;
  bool get agreement => _agreement.value;
  AcademyPartner? get partnerStatus => _partnerStatus.value;
}
