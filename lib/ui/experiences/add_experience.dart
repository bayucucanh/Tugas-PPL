import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/experiences/controller/experience_add.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddExperience extends GetView<ExperienceAddController> {
  static const routeName = '/experiences/add';
  const AddExperience({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ExperienceAddController());
    return DefaultScaffold(
      title: 'Tambah Pengalaman'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: [
        TextButton(onPressed: controller.save, child: 'Simpan'.text.make()),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.title,
            decoration: const InputDecoration(hintText: 'Judul'),
            validator: (value) {
              return FormRules.validate(
                rules: ['required'],
                value: value,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          Obx(
            () => VStack([
              if (controller.file.value.path != null)
                controller.imageTypes.contains(controller.file.value.extension)
                    ? Image.file(controller.file.value.toFile)
                        .wh(150, 150)
                        .centered()
                    : Thumbnail(
                        mimeType: 'application/pdf',
                        widgetSize: 150,
                        decoration: WidgetDecoration(
                          backgroundColor: Colors.blueAccent,
                          iconColor: Colors.red,
                        ),
                        dataResolver: () => controller.file.value.asUint8List,
                      ).centered(),
              UiSpacer.verticalSpace(space: 10),
              TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    hintText: (controller.file.value.path == null
                        ? 'Pilih File'
                        : 'Ubah File')),
                validator: (value) {
                  if (controller.file.value.path == null) {
                    return 'File tidak boleh kosong';
                  }
                  return null;
                },
                onTap: controller.selectFile,
                readOnly: true,
              ),
            ]),
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(hintText: 'Deskripsi (Opsional)'),
            maxLength: 150,
            minLines: 5,
            maxLines: 5,
          ),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
