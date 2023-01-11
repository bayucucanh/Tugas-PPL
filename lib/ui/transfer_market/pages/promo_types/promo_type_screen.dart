import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/add_promo.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PromoTypeScreen extends GetView<AddPromoController> {
  const PromoTypeScreen({Key? key}) : super(key: key);

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
          itemCount: controller.typePromo
              .getTypes(controller.targetPromo.selectedTarget?.id)
              .length,
          itemBuilder: (context, index) {
            final type = controller.typePromo
                .getTypes(controller.targetPromo.selectedTarget?.id)[index];
            return VStack(
              [
                SvgPicture.asset(
                  type.imagePath!,
                  color: controller.typePromo.selectedType?.id == type.id
                      ? primaryColor
                      : Colors.black,
                ).wh(100, 100),
                UiSpacer.verticalSpace(),
                (type.name ?? '-').text.make(),
              ],
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            ).onInkTap(() => controller.typePromo.selectType(type));
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: controller.typePromo.selectedType?.id == null
              ? Colors.grey
              : primaryColor,
          onPressed: controller.typePromo.selectedType?.id == null
              ? null
              : controller.nextPage,
          child: const Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}
