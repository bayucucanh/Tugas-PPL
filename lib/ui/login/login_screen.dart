import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/ui/login/controller/login_controller.dart';
import 'package:mobile_pssi/ui/register/register_screen.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends GetView<LoginController> {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      body: Obx(
        () => ZStack([
          Image.asset(
            loginBackground,
            fit: BoxFit.fill,
            color: Get.theme.backgroundColor.withOpacity(0.6),
            colorBlendMode: BlendMode.darken,
          ).whFull(context),
          VStack(
            [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  loginHeader,
                ),
              ).box.height(180).width(250).alignCenter.makeCentered(),
              UiSpacer.verticalSpace(space: 10),
              Form(
                key: controller.formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: VStack(
                    [
                      'Login'
                          .text
                          .align(TextAlign.left)
                          .textStyle(loginHeaderFontTextStyles)
                          .make(),
                      UiSpacer.verticalSpace(),
                      'Username/E-mail'
                          .text
                          .align(TextAlign.left)
                          .textStyle(loginTitleFontTextStyles)
                          .make(),
                      TextFormComponent(
                        label: 'Username/E-mail',
                        textInputAction: TextInputAction.next,
                        controller: controller.usernameController,
                        validator: (value) =>
                            value!.isBlank! ? 'fill_out_field'.tr : null,
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
                          color: primaryColor,
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        validator: (value) =>
                            value!.isBlank! ? 'fill_out_field'.tr : null,
                        controller: controller.passwordController,
                      ),
                      UiSpacer.verticalSpace(),
                      'Lupa kata sandi?'
                          .text
                          .xs
                          .color(primaryColor)
                          .make()
                          .objectCenterRight()
                          .onTap(controller.goToForgotPassword),
                      UiSpacer.verticalSpace(),
                      Obx(
                        () => controller.isLoadingNative.value == true
                            ? const CircularProgressIndicator().centered()
                            : 'login'
                                .tr
                                .text
                                .textStyle(buttonTextStyle)
                                .makeCentered()
                                .continuousRectangle(
                                  height: 40,
                                  backgroundColor: primaryColor,
                                )
                                .onTap(controller.doLogin),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: 'or'
                            .tr
                            .text
                            .textStyle(loginCaptionFontTextStyles)
                            .make()
                            .p12(),
                      ),
                      'register'
                          .tr
                          .text
                          .white
                          .makeCentered()
                          .continuousRectangle(
                              height: 40,
                              backgroundColor: primaryColor.withOpacity(0.8),
                              borderSide: const BorderSide(
                                  width: 1, color: primaryColor))
                          .onTap(() => Get.toNamed(RegisterScreen.routeName)),
                      UiSpacer.verticalSpace(),
                      HStack(
                        [
                          controller.isLoadingGoogle.value == true
                              ? const CircularProgressIndicator()
                                  .centered()
                                  .expand()
                              : HStack(
                                  [
                                    const Icon(
                                      FontAwesomeIcons.google,
                                      color: Vx.white,
                                      size: 18,
                                    ),
                                    UiSpacer.horizontalSpace(space: 5),
                                    "Sign In With Google"
                                        .text
                                        .sm
                                        .white
                                        .center
                                        .make()
                                        .expand()
                                  ],
                                  alignment: MainAxisAlignment.center,
                                  crossAlignment: CrossAxisAlignment.center,
                                )
                                  .box
                                  .p8
                                  .withDecoration(
                                    BoxDecoration(
                                      color: const Color(0xff4383f2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                  .margin(const EdgeInsets.only(right: 4))
                                  .make()
                                  .onTap(controller.signInWithGoogle)
                                  .expand(),
                          if (controller.isPlatformIos.value == false)
                            controller.isLoadingFacebook.value == true
                                ? const CircularProgressIndicator()
                                    .centered()
                                    .expand()
                                : HStack(
                                    [
                                      const Icon(
                                        FontAwesomeIcons.facebook,
                                        size: 18,
                                      ),
                                      UiSpacer.horizontalSpace(space: 4),
                                      "Sign In With Facebook"
                                          .text
                                          .white
                                          .sm
                                          .center
                                          .make()
                                          .expand()
                                    ],
                                    alignment: MainAxisAlignment.center,
                                    crossAlignment: CrossAxisAlignment.center,
                                  )
                                    .box
                                    .p8
                                    .withDecoration(
                                      BoxDecoration(
                                        color: const Color(0xff395795),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    )
                                    .make()
                                    .onTap(controller.signInWithFacebook)
                                    .expand(),
                          if (controller.isPlatformIos.value &&
                              controller.appleSignInAvailable.value)
                            controller.isLoadingApple.value == true
                                ? const CircularProgressIndicator()
                                    .centered()
                                    .expand()
                                : HStack(
                                    [
                                      const Icon(
                                        FontAwesomeIcons.apple,
                                        color: Vx.white,
                                        size: 18,
                                      ),
                                      UiSpacer.horizontalSpace(space: 5),
                                      "Sign In With Apple".text.sm.white.make()
                                    ],
                                    alignment: MainAxisAlignment.center,
                                    crossAlignment: CrossAxisAlignment.center,
                                  )
                                    .box
                                    .p8
                                    .withDecoration(
                                      BoxDecoration(
                                        color: const Color(0xff060709),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    )
                                    .make()
                                    .onTap(controller.signInWithApple)
                                    .expand(),
                        ],
                        alignment: MainAxisAlignment.spaceEvenly,
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                      UiSpacer.verticalSpace(),
                      RichText(
                        text: TextSpan(
                          style: loginCaptionFontTextStyles,
                          children: [
                            const TextSpan(
                                text:
                                    'Dengan daftar atau login, kamu setuju dengan ',
                                style: TextStyle(color: textLoginColor)),
                            TextSpan(
                                text: 'syarat layanan ',
                                style: const TextStyle(color: primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.openTos),
                            const TextSpan(
                                text: 'dan ',
                                style: TextStyle(color: textLoginColor)),
                            TextSpan(
                                text: 'kebijakan pribadi',
                                style: const TextStyle(color: primaryColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.openPrivacy),
                            const TextSpan(
                              text: '.',
                              style: TextStyle(color: textLoginColor),
                            ),
                          ],
                        ),
                      ).pOnly(top: 24)
                    ],
                    alignment: MainAxisAlignment.center,
                    crossAlignment: CrossAxisAlignment.start,
                  ).box.px24.make(),
                ),
              ),
            ],
          )
              .box
              .margin(const EdgeInsets.all(8))
              .make()
              .scrollVertical()
              .safeArea(),
        ]),
      ),
    );
  }
}
