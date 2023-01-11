import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/class_category/controller/add_class_category.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddClassCategory extends GetView<AddClassCategoryController> {
  static const routeName = '/class-category/add';
  const AddClassCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddClassCategoryController());
    return DefaultScaffold(
      title: 'Tambah Kategori Kelas'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      actions: [
        TextButton(
          onPressed: controller.isUploading.value ? null : controller.save,
          child: 'Simpan'.text.make(),
        )
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          ImageUpload(
            context: context,
            onSaved: controller.selectFile,
            changeLabel: 'Ubah Image Icon',
            selectLabel: 'Pilih Image Icon',
            validator: (value) {
              return null;
            },
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.name,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Nama Kategori',
              labelText: 'Nama Kategori',
            ),
          ),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(
              hintText: 'Deskripsi Kategori',
              labelText: 'Deskripsi Kategori',
            ),
            minLines: 5,
            maxLines: 5,
          ),
        ]).scrollVertical().p12(),
      ),
    );
  }
}
