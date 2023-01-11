import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AttackTacticForm extends GetView<TestParameterController> {
  static const routeName = '/test/parameters/tactic';
  const AttackTacticForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Taktik'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.openMentalForm,
          child: 'Next'.text.make(),
        ),
      ],
      body: Form(
        key: controller.attackTacticForm,
        child: VStack([
          'Masukan link video permainan sepak bola kamu dan pastikan video berdurasi minimal 10 menit tanpa ada potongan atau editan.'
              .text
              .sm
              .make(),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.tacticForm?.linkText,
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Tidak boleh kosong.';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Link Video',
              isDense: true,
              helperText: 'Masukan link video',
            ),
          ),
        ]).p12().safeArea(),
      ),
    );
  }
}
