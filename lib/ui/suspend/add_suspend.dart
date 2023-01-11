import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/suspend/controller/add_suspend.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddSuspend extends GetView<AddSuspendController> {
  static const routeName = '/suspends/add';
  const AddSuspend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddSuspendController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Tambah Suspend'.text.make(),
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
                hintText: 'Nama Suspend',
                labelText: 'Nama Suspend',
              ),
            ),
            HStack([
              TextFormField(
                controller: controller.value,
                decoration: const InputDecoration(
                  hintText: 'Nilai',
                  labelText: 'Nilai',
                ),
                keyboardType: TextInputType.number,
                enabled:
                    controller.selectedDuration.value.id != null ? true : false,
              ).expand(),
              UiSpacer.horizontalSpace(space: 10),
              DropdownButtonFormField(
                items: controller.durations
                    .map((duration) => DropdownMenuItem(
                        value: duration,
                        child: (duration.name ?? '-').text.make()))
                    .toList(),
                decoration: const InputDecoration(
                  hintText: 'Durasi',
                  labelText: 'Durasi',
                ),
                onChanged: controller.changeDuration,
              ).expand(),
            ]),
          ]).p12(),
        ),
      ),
    );
  }
}
