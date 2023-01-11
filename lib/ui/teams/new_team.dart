import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/teams/controller/new_team.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTeam extends GetView<NewTeamController> {
  static const routeName = '/teams/add';
  const NewTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewTeamController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tim Baru'.text.make(),
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
              decoration: const InputDecoration(
                hintText: 'Kelompok Usia',
                labelText: 'Kelompok Usia',
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
              decoration: const InputDecoration(
                hintText: 'Jenis Kelamin',
                labelText: 'Jenis Kelamin',
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
