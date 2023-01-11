import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/security_account/controller/change_password.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  static const routeName = '/change-password';
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Ubah Kata Sandi'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.save,
          child: 'Simpan'.text.make(),
        )
      ],
      body: Form(
        key: controller.formKey,
        child: VStack(
          [
            FancyPasswordField(
              controller: controller.newPassword,
              hasShowHidePassword: true,
              hasStrengthIndicator: true,
              hasValidationRules: true,
              validationRules: {
                DigitValidationRule(),
                UppercaseValidationRule(),
                LowercaseValidationRule(),
                MinCharactersValidationRule(8),
              },
              decoration: const InputDecoration(
                  hintText: 'Kata sandi baru', labelText: 'Kata sandi baru'),
            ),
            FancyPasswordField(
              controller: controller.confirmNewPassword,
              hasShowHidePassword: true,
              hasValidationRules: false,
              hasStrengthIndicator: false,
              validationRules: {
                DigitValidationRule(),
                UppercaseValidationRule(),
                LowercaseValidationRule(),
                MinCharactersValidationRule(8),
              },
              decoration: const InputDecoration(
                  hintText: 'Konfirmasi kata sandi baru',
                  labelText: 'Konfirmasi kata sandi baru'),
            ),
          ],
        ).p12().scrollVertical(),
      ),
    );
  }
}
