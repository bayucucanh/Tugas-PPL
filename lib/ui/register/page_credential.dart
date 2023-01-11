import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/ui/register/controller/register_controller.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PageCredential extends GetView<RegisterController> {
  const PageCredential({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: controller.formKeyCredentials,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: VStack(
            [
              UiSpacer.verticalSpace(space: 32),
              'Username'
                  .text
                  .align(TextAlign.left)
                  .textStyle(loginTitleFontTextStyles)
                  .make(),
              TextFormComponent(
                label: "Username",
                textInputAction: TextInputAction.next,
                controller: controller.usernameController,
                validator: (value) =>
                    value!.isBlank! ? 'fill_password'.tr : null,
              ),
              UiSpacer.verticalSpace(),
              'Password'
                  .text
                  .align(TextAlign.left)
                  .textStyle(loginTitleFontTextStyles)
                  .make(),
              TextFormComponent(
                label: 'password'.tr,
                obscureText: controller.passwordVisibility.value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (String value) {
                  // controller.doLogin();
                },
                suffixIcon: IconButton(
                  icon: Icon(controller.passwordVisibility.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  color: Get.theme.primaryColorDark,
                  onPressed: () {
                    controller.togglePasswordVisibility();
                  },
                ),
                validator: (value) =>
                    value!.isBlank! ? 'fill_password'.tr : null,
                controller: controller.passwordController,
              ),
              UiSpacer.verticalSpace(),
              'Konfirmasi Password'
                  .text
                  .align(TextAlign.left)
                  .textStyle(loginTitleFontTextStyles)
                  .make(),
              TextFormComponent(
                label: 'password'.tr,
                obscureText: controller.confirmPasswordVisibility.value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (String value) {
                  // controller.doLogin();
                },
                suffixIcon: IconButton(
                  icon: Icon(controller.confirmPasswordVisibility.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  color: Get.theme.primaryColorDark,
                  onPressed: () {
                    controller.toggleConfirmPasswordVisibility();
                  },
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'fill_password'.tr;
                  }
                  if (value != controller.passwordController.text) {
                    return 'not_match'.tr;
                  }
                  return null;
                },
                controller: controller.confirmPasswordController,
              ),
              UiSpacer.verticalSpace(),
            ],
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.start,
          ),
        ),
      ).scrollVertical(),
    );
  }
}
