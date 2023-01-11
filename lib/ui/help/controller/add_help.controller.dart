import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/help.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddHelpController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _helpRequest = HelpRequest();
  final title = TextEditingController();
  final htmlEditor = HtmlEditorController();
  final uploading = false.obs;

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        uploading(true);
        EasyLoading.show();
        await _helpRequest.add(
            title: title.text,
            content: html2md.convert(await htmlEditor.getText()));
        EasyLoading.dismiss();
        uploading(false);
        title.clear();
        htmlEditor.clear();
        getSnackbar('Informasi', 'Berhasil membuat faq');
      }
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
