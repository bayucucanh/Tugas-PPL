import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/help/controller/edit_help.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EditHelp extends GetView<EditHelpController> {
  static const routeName = '/help/edit';
  const EditHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditHelpController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Ubah FAQ'.text.make(),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.uploading.value ? null : controller.save,
            child: 'Simpan'.text.make(),
          ),
        ),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.title,
            validator: ValidationBuilder(localeName: 'id')
                .required()
                .minLength(3)
                .build(),
            decoration: const InputDecoration(
              hintText: 'Judul',
              labelText: 'Judul',
            ),
          ),
          UiSpacer.verticalSpace(),
          TextButtonTheme(
            data: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                textStyle: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
            child: HtmlEditor(
              controller: controller.htmlEditor,
              callbacks: Callbacks(
                onInit: controller.initialize,
              ),
              htmlToolbarOptions: const HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeExpandable,
                defaultToolbarButtons: [
                  StyleButtons(),
                  FontSettingButtons(),
                  ColorButtons(),
                  ListButtons(),
                  ParagraphButtons(),
                  InsertButtons(
                      link: true, picture: false, audio: false, video: false),
                ],
              ),
              htmlEditorOptions: const HtmlEditorOptions(
                hint: "Konten",
                adjustHeightForKeyboard: true,
                androidUseHybridComposition: true,
              ),
              otherOptions: const OtherOptions(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide.none),
                ),
              ),
            ),
          ),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
