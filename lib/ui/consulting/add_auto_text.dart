import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/consulting/controller/add_auto_text.controller.dart';
import 'package:mobile_pssi/ui/consulting/parts/media_manager.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAutoText extends GetView<AddAutoTextController> {
  static const routeName = '/auto-text/add';
  const AddAutoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddAutoTextController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Auto Text'.text.make(),
      actions: [
        Obx(
          () => controller.showDeleteAttachment.value == true
              ? IconButton(
                  icon: const Icon(Icons.delete_forever_rounded),
                  onPressed: controller.removeAttachments,
                )
              : TextButton(
                  onPressed:
                      controller.isUploading.value ? null : controller.save,
                  child: 'Simpan'.text.make(),
                ),
        ),
      ],
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: VStack([
            TextFormField(
              controller: controller.shortcut,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Shortcut',
                labelText: 'Shortcut',
              ),
            ),
            if (controller.files.isEmpty)
              TextFormField(
                controller: controller.message,
                decoration: InputDecoration(
                  hintText: 'Pesan',
                  labelText: 'Pesan',
                  suffixIcon: IconButton(
                    onPressed: controller.selectFiles,
                    icon: const Icon(Icons.perm_media_rounded),
                  ),
                  helperText: 'Masukan text atau pilih media',
                ),
                minLines: 1,
                maxLines: 4,
              ),
            if (controller.files.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final file = controller.files[index];
                  return GestureDetector(
                    onLongPress: controller.toggleDeleteIcon,
                    onLongPressCancel: controller.toggleDeleteIcon,
                    child: MediaManager(file: file).h(120).p8(),
                  );
                },
                itemCount: controller.files.length,
                physics: const NeverScrollableScrollPhysics(),
              ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
