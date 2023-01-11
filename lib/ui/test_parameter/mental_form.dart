import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/mental_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class MentalForm extends GetView<TestParameterController> {
  static const routeName = '/test/parameters/mental-form';
  const MentalForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Mental: Sport Competition Anxiety'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.requestVerification,
          child: 'Selesai'.text.make(),
        ),
      ],
      body: Obx(
        () => Form(
          key: controller.mentalForm,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final performanceForm = controller.mentalItems?[index];
              return MentalFormField(
                index: index,
                performanceForm: performanceForm!,
                rarely: () => controller.metalSelection(performanceForm, 0),
                sometimes: () => controller.metalSelection(performanceForm, 1),
                often: () => controller.metalSelection(performanceForm, 2),
              );
            },
            itemCount: controller.mentalItems?.length ?? 0,
          ).p12().safeArea(),
        ),
      ),
    );
  }
}
