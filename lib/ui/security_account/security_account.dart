import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/security_account/controller/security_account.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SecurityAccount extends GetView<SecurityAccountController> {
  static const routeName = '/security';
  const SecurityAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityAccountController());
    return DefaultScaffold(
      title: 'Data Keamanan Akun'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: Obx(
        () => ListView(
          children: [
            ListTile(
              title: 'Ubah Kata Sandi'.text.make(),
              onTap: controller.openChangePassword,
            ),
            SwitchListTile(
              activeColor: primaryColor,
              title: 'Hubungkan ke Google'.text.make(),
              value: controller.connectedGoogle.value,
              onChanged: controller.toggleGoogle,
            ),
            SwitchListTile(
              activeColor: primaryColor,
              title: 'Hubungkan ke Facebook'.text.make(),
              value: controller.connectedFacebook.value,
              onChanged: controller.toggleFacebook,
            ),
            if (GetPlatform.isIOS)
              SwitchListTile(
                activeColor: primaryColor,
                title: 'Hubungkan ke Apple'.text.make(),
                value: controller.connectedApple.value,
                onChanged: controller.toggleApple,
              ),
            UiSpacer.verticalSpace(),
            ListTile(
              title: 'Hapus Akun'.text.white.makeCentered(),
              onTap: controller.removeAccount,
            ).box.color(primaryColor).roundedLg.make().p12(),
          ],
        ),
      ),
    );
  }
}
