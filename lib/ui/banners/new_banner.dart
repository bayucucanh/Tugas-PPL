import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/banners/controller/new_banner.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class NewBanner extends GetView<NewBannerController> {
  static const routeName = '/banners/new';
  const NewBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewBannerController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      title: 'Banner Baru'.text.make(),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.uploading.value ? null : controller.upload,
            child: 'Simpan'.text.make(),
          ),
        ),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            validator: ValidationBuilder(localeName: 'id').minLength(3).build(),
            controller: controller.title,
            decoration:
                const InputDecoration(hintText: 'Judul', labelText: 'Judul'),
          ),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(
                hintText: 'Deskripsi', labelText: 'Deskripsi'),
            minLines: 5,
            maxLines: 5,
          ),
          UiSpacer.verticalSpace(),
          ImageUpload(
            context: context,
            onSaved: controller.selectFile,
            validator: (value) {
              if (value?.name == null) {
                return 'Gambar harus dipilih.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: controller.link,
            decoration: const InputDecoration(
              hintText: 'Link Website',
              labelText: 'Link Website',
            ),
          ),
          HStack([
            TextFormField(
              controller: controller.duration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Durasi',
                labelText: 'Durasi',
              ),
            ).expand(),
            UiSpacer.horizontalSpace(),
            DropdownButtonFormField(
              items: controller.units
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: (e.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.selectUnit,
              decoration: const InputDecoration(
                hintText: 'Unit',
                labelText: 'Unit',
              ),
            ).expand(),
          ]),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
