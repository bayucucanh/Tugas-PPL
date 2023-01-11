import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/register/controller/register_controller.dart';
import 'package:mobile_pssi/ui/register/page_credential.dart';
import 'package:mobile_pssi/ui/register/page_otp.dart';
import 'package:mobile_pssi/ui/register/page_select_user.dart';
import 'package:mobile_pssi/ui/register/page_user_data.dart';
import 'package:progress_stepper/progress_stepper.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterScreen extends GetView<RegisterController> {
  static const routeName = '/login/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Obx(
      () => WillPopScope(
        onWillPop: controller.onBackPressed,
        child: DefaultScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Get.theme.backgroundColor,
          title: controller.titlePage.value.text.xl.white.semiBold.make(),
          leading: GestureDetector(
              onTap: controller.backPage,
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          body: VStack(
            [
              VStack(
                [
                  ProgressStepper(
                    width: double.infinity,
                    height: 18,
                    color: stepperColor,
                    progressColor: stepperColor,
                    stepCount: 4,
                    builder: (index) {
                      double widthOfStep = Get.width * 0.2;
                      if (controller.currentIndex.value == index - 1) {
                        return ProgressStepWithChevron(
                          width: widthOfStep,
                          defaultColor: stepperColor.withOpacity(0.2),
                          progressColor: stepperColor,
                          wasCompleted: true,
                        );
                      } else {
                        return ProgressStepWithChevron(
                          width: widthOfStep,
                          defaultColor: stepperColor.withOpacity(0.2),
                          progressColor: stepperColor,
                          wasCompleted: false,
                        );
                      }
                    },
                  ).pOnly(bottom: 8),
                ],
              ),
              Flexible(
                child: PageView(
                  controller: controller.pageController,
                  // allowImplicitScrolling: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    PageSelectUser(),
                    PageUserData(),
                    PageCredential(),
                    PageOTP()
                  ],
                ),
              ),
              controller.nextButton()
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.center,
          ).p12(),
        ),
      ),
    );
  }
}
