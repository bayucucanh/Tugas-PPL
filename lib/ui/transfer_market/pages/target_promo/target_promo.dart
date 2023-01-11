import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/add_promo.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TargetPromo extends GetView<AddPromoController> {
  const TargetPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: controller.targetPromo.targets.length,
          itemBuilder: (context, index) {
            final target = controller.targetPromo.targets[index];
            return VStack(
              [
                SvgPicture.asset(
                  target.imagePath!,
                  color: controller.targetPromo.selectedTarget?.id == target.id
                      ? primaryColor
                      : Colors.black,
                ).wh(100, 100),
                UiSpacer.verticalSpace(),
                (target.name ?? '-').text.make(),
              ],
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            ).onInkTap(() => controller.targetPromo.selectTarget(target));
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: controller.targetPromo.selectedTarget?.id == null
              ? Colors.grey
              : primaryColor,
          onPressed: controller.targetPromo.selectedTarget?.id == null
              ? null
              : controller.nextPage,
          child: const Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}
