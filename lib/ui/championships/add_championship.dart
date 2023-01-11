import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/championships/controller/championship_add.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddChampionship extends GetView<ChampionshipAddController> {
  static const routeName = '/championship/add';
  const AddChampionship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChampionshipAddController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Kejuaraan'.text.sm.make(),
      actions: [
        TextButton(onPressed: controller.save, child: 'Simpan'.text.make()),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.name,
            decoration: const InputDecoration(hintText: 'Nama Kejuaraan'),
            validator: (value) {
              return FormRules.validate(
                rules: ['required'],
                value: value,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.position,
            decoration: const InputDecoration(hintText: 'Posisi Kejuaraan'),
            validator: (value) {
              return FormRules.validate(
                rules: ['required'],
                value: value,
              );
            },
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.year,
            decoration:
                const InputDecoration(hintText: 'Tahun Kejuaraan (Opsional)'),
          ),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
