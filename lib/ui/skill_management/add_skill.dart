import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/skill_management/controller/add_skill.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class AddSkill extends GetView<AddSkillController> {
  static const routeName = '/skills/add';
  const AddSkill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddSkillController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Topik Keahlian'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.isUploading.value ? null : controller.save,
          child: 'Simpan'.text.make(),
        )
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.name,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Nama Topik Keahlian',
              labelText: 'Nama Topik Keahlian',
            ),
          ),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(
              hintText: 'Deskripsi Topik Keahlian',
              labelText: 'Deskripsi Topik Keahlian',
            ),
            minLines: 5,
            maxLines: 5,
          ),
        ]).p12(),
      ),
    );
  }
}
