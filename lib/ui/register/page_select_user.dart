import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/ui/register/controller/register_controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PageSelectUser extends GetView<RegisterController> {
  const PageSelectUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.userTypes.length,
      itemBuilder: (context, index) => Obx(
        () => GestureDetector(
          onTap: () => controller.selectUserType(controller.userTypes[index]),
          child: HStack([
            VStack(
              [
                AnimatedOpacity(
                  opacity: controller.selectedUserType.value.id ==
                          controller.userTypes[index].id
                      ? 1
                      : 0.2,
                  duration: const Duration(milliseconds: 250),
                  child: Image.asset(controller.userTypes[index].imagePath!),
                ),
                (controller.userTypes[index].name ?? '-')
                    .text
                    .textStyle(registerCaptionActiveStyles)
                    .make(),
              ],
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            ),
            UiSpacer.horizontalSpace(),
            VStack([
              (controller.userTypes[index].title ?? '').text.semiBold.sm.make(),
              (controller.userTypes[index].description ?? '').text.sm.make()
            ]).expand(),
          ]),
        ),
      ),
    ).p12();
  }
}
