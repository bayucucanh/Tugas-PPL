import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabTechnique extends GetView<VerifyTestParamsController> {
  const TabTechnique({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final technique = controller.techniqueItems?[index];
          return HStack([
            VStack([
              (technique?.performanceItem?.name ?? '-').text.semiBold.make(),
              UiSpacer.verticalSpace(space: 5),
              HStack([
                TextFormField(
                  controller: technique?.realization,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return 'Tidak boleh kosong.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Realisasi'),
                ).expand(),
                UiSpacer.horizontalSpace(space: 10),
                TextFormField(
                  controller: technique?.actualScore,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return 'Tidak boleh kosong.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Aktual'),
                ).expand(),
              ])
            ]).expand(),
            IconButton(
              onPressed: () => controller.changeVideo(technique?.linkVideo),
              icon: const Icon(Icons.play_arrow_rounded),
            )
          ]).py12();
        },
        itemCount: controller.techniqueItems?.length ?? 0,
      ),
    );
  }
}
