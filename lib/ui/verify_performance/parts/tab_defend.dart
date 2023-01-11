import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabDefend extends GetView<VerifyTestParamsController> {
  const TabDefend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final defendTactic = controller.defendItems?[index];
          return HStack([
            VStack([
              (defendTactic?.performanceItem?.name ?? '-').text.semiBold.make(),
              UiSpacer.verticalSpace(space: 5),
              TextFormField(
                controller: defendTactic?.actualScore,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                validator: (value) {
                  if (value.isEmptyOrNull) {
                    return 'Tidak boleh kosong.';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Aktual'),
              ),
            ]).expand(),
            IconButton(
              onPressed: () => controller.changeVideo(defendTactic?.linkVideo),
              icon: const Icon(Icons.play_arrow_rounded),
            )
          ]).py12();
        },
        itemCount: controller.defendItems?.length ?? 0,
      ),
    );
  }
}
