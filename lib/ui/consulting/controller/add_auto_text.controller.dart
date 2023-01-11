import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/quick_reply.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddAutoTextController extends BaseController {
  final _quickReplyRequest = QuickReplyRequest();

  final formKey = GlobalKey<FormState>();
  final shortcut = TextEditingController();
  final message = TextEditingController();
  final files = <FileObservable>[].obs;
  final isUploading = false.obs;
  final showDeleteAttachment = false.obs;

  selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Pilih File',
      allowMultiple: true,
      allowedExtensions: [
        'jpg',
        'png',
        'mp4',
      ],
      type: FileType.custom,
    );

    if (result != null) {
      if (result.count > 5) {
        getSnackbar('Informasi', 'Tidak dapat memilih lebih dari 5 file.');
        return;
      }
      files(
          result.files.map((e) => FileObservable.multiPickResult(e)).toList());
    }
  }

  toggleDeleteIcon() {
    showDeleteAttachment.toggle();
  }

  removeAttachments() {
    files.clear();
    showDeleteAttachment(false);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _quickReplyRequest.create(
            shortcut: shortcut.text, message: message.text, files: files);
        isUploading(false);
        EasyLoading.dismiss();

        Get.back(result: 'success');
      }
    } catch (e) {
      isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
