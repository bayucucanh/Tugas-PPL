import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/recent_educations/controller/education_add.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddEducation extends GetView<EducationAddController> {
  static const routeName = '/education/add';
  const AddEducation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EducationAddController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Riwayat Pendidikan'.text.sm.make(),
      actions: [
        TextButton(onPressed: controller.save, child: 'Simpan'.text.make()),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          'Kategori Sekolah'.text.semiBold.make(),
          UiSpacer.verticalSpace(space: 5),
          Obx(
            () => ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.categories.toList(),
              onPressed: controller.changeCategory,
              children: [
                'Formal'.text.make().p8(),
                'Non-Formal'.text.make().p8(),
              ],
            ).h(40).centered(),
          ),
          UiSpacer.verticalSpace(space: 10),
          TextFormField(
            controller: controller.schoolName,
            decoration: const InputDecoration(hintText: 'Nama Sekolah'),
            validator: (value) {
              return FormRules.validate(
                rules: ['required'],
                value: value,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.degree,
            decoration:
                const InputDecoration(hintText: 'Gelar - Jurusan (Opsional)'),
          ),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
