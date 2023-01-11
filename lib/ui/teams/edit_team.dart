import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/teams/controller/edit_team.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EditTeam extends GetView<EditTeamController> {
  static const routeName = '/teams/edit';
  const EditTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditTeamController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Ubah Tim'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.isUploading.value ? null : controller.save,
          child: 'Simpan'.text.make(),
        )
      ],
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: VStack([
            ImageUpload(
                context: context,
                selectLabel: 'Pilih Logo Tim',
                changeLabel: 'Ubah Logo Tim',
                placeholder: controller.team?.imageUrl,
                onSaved: controller.selectFile,
                validator: (val) {
                  return null;
                }),
            UiSpacer.verticalSpace(),
            TextFormField(
              controller: controller.teamName,
              decoration: const InputDecoration(
                hintText: 'Nama Tim',
                labelText: 'Nama Tim',
              ),
              validator: (value) {
                return FormRules.validate(rules: [
                  'required',
                ], value: value);
              },
            ),
            UiSpacer.verticalSpace(),
            DropdownButtonFormField(
              items: controller.ageGroups.value.data
                  ?.map((ageGroup) => DropdownMenuItem(
                        value: ageGroup,
                        child: (ageGroup.name ?? '-').text.make(),
                      ))
                  .toList(),
              validator: (value) {
                if (controller.selectedAgeGroup.value.id == null) {
                  return 'Kelompok usia harus dipilih';
                }
                return null;
              },
              onChanged: controller.changeAgeGroup,
              decoration: InputDecoration(
                hintText:
                    controller.selectedAgeGroup.value.name ?? 'Kelompok Usia',
                labelText: 'Kelompok Usia',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            UiSpacer.verticalSpace(),
            DropdownButtonFormField(
              items: controller.genders
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: (gender.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.changeGender,
              decoration: InputDecoration(
                hintText:
                    controller.selectedGender.value.name ?? 'Jenis Kelamin',
                labelText: 'Jenis Kelamin',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (controller.selectedGender.value.id == null) {
                  return 'Jenis kelamin harus dipilih';
                }
                return null;
              },
            ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
