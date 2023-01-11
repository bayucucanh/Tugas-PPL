import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/forgot_password/controller/forgot_password.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPassword extends GetView<ForgotPasswordController> {
  static const routeName = '/forgot-password';
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());
    return DefaultScaffold(
      title: 'Lupa Kata Sandi'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: Form(
        key: controller.formKey,
        child: VStack(
          [
            'Untuk melakukan perubahan kata sandi, masukan alamat email yang terdaftar pada ${F.title.toLowerCase()} kemudian tunggu hingga mendapatkan email untuk cara merubah kata sandi.'
                .text
                .sm
                .make(),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                hintText: 'Alamat E-mail',
                labelText: 'Alamat E-mail',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                if (!value.isEmail) {
                  return 'Alamat email tidak valid';
                }
                return null;
              },
            ),
            UiSpacer.verticalSpace(),
            Obx(
              () => 'Lupa Kata Sandi'
                  .text
                  .white
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    backgroundColor: controller.isSendingData.value
                        ? Colors.grey
                        : primaryColor,
                  )
                  .onInkTap(controller.isSendingData.value
                      ? null
                      : controller.sendForgotPassword),
            ),
          ],
        ).p12().scrollVertical(),
      ),
    );
  }
}
