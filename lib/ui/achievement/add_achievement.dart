import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/achievement/controller/achievement_add.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAchievement extends GetView<AchievementAddController> {
  static const routeName = '/achievement/add';
  const AddAchievement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AchievementAddController());
    return DefaultScaffold(
      title: 'Tambah Penghargaan'.text.make(),
      actions: [
        TextButton(onPressed: controller.save, child: 'Simpan'.text.make()),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack(
          [
            TextFormField(
              controller: controller.title,
              decoration: const InputDecoration(hintText: 'Nama Penghargaan'),
              validator: (value) {
                return FormRules.validate(
                  rules: ['required'],
                  value: value,
                );
              },
            ),
            UiSpacer.verticalSpace(space: 10),
            TextFormField(
              controller: controller.year,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Tahun Penghargaan'),
              validator: (value) {
                return FormRules.validate(
                  rules: ['required'],
                  value: value,
                );
              },
            ),
          ],
        ).p12().scrollVertical(),
      ),
    );
  }
}
