import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:markdown/markdown.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/help.dart';
import 'package:mobile_pssi/data/requests/help.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EditHelpController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final _helpRequest = HelpRequest();
  final title = TextEditingController();
  final htmlEditor = HtmlEditorController();
  final uploading = false.obs;
  final _help = Help().obs;

  EditHelpController() {
    _help(Help.fromJson(Get.arguments));
  }

  initialize() {
    title.text = _help.value.title ?? '';
    EasyLoading.show();
    String markdown = markdownToHtml(_help.value.content ?? '');
    htmlEditor.setText(markdown);
    EasyLoading.dismiss();
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        uploading(true);
        EasyLoading.show();
        await _helpRequest.update(
            slug: _help.value.slug!,
            title: title.text,
            content: html2md.convert(await htmlEditor.getText()));
        EasyLoading.dismiss();
        uploading(false);
        getSnackbar('Informasi', 'Berhasil mengubah faq');
      }
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
