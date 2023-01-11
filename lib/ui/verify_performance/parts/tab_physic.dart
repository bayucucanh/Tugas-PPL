import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabPhsyic extends GetView<VerifyTestParamsController> {
  const TabPhsyic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final phsyic = controller.physicItems?[index];
          return HStack([
            VStack([
              (phsyic?.performanceItem?.name ?? '-').text.semiBold.make(),
              UiSpacer.verticalSpace(space: 5),
              HStack([
                TextFormField(
                  controller: phsyic?.realization,
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
                  controller: phsyic?.actualScore,
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
              onPressed: () => controller.changeVideo(phsyic?.linkVideo),
              icon: const Icon(Icons.play_arrow_rounded),
            )
          ]).py12();
        },
        itemCount: controller.physicItems?.length ?? 0,
      ),
    );
  }
}
