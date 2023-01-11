import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/performance_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class PhysicForm extends GetView<TestParameterController> {
  static const routeName = '/test/parameters/physic';
  const PhysicForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Form Fisik'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        TextButton(
          onPressed: controller.openAttackTacticForm,
          child: 'Next'.text.make(),
        ),
        // TextButton(
        //   onPressed: controller.requestVerification,
        //   child: 'Minta Verifikasi'.text.make(),
        // ),
      ],
      body: Form(
        key: controller.physicForm,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final performanceForm = controller.phsyicItems?[index];
            return PerformanceFormField(performanceForm: performanceForm!);
          },
          itemCount: controller.phsyicItems?.length ?? 0,
        ).p12(),
      ),
    );
  }
}
