import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/performance_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class DefendTacticForm extends GetView<TestParameterController> {
  static const routeName = '/test/parameters/defend-tactic';
  const DefendTacticForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Taktik: Defending'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.openMentalForm,
          child: 'Next'.text.make(),
        ),
      ],
      body: Form(
        key: controller.defendTacticForm,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final performanceForm = controller.defendTacticItems?[index];
            return PerformanceFormField(performanceForm: performanceForm!);
          },
          itemCount: controller.defendTacticItems?.length ?? 0,
        ).p12().safeArea(),
      ),
    );
  }
}
