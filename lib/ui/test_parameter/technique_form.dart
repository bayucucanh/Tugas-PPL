import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/performance_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class TechniqueForm extends GetView<TestParameterController> {
  static const routeName = '/test/parameters/technique';
  const TechniqueForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      title: 'Form Teknik'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.openPhysicForm,
          child: 'Next'.text.make(),
        ),
      ],
      body: Form(
        key: controller.techniqueForm,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final performanceForm = controller.techniqueItems?[index];
            return PerformanceFormField(performanceForm: performanceForm!);
          },
          itemCount: controller.techniqueItems?.length ?? 0,
        ).p12(),
      ),
    );
  }
}
