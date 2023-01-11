import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/table_average_level_anxiety_mental_reference.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/table_high_level_anxiety_mental_reference.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/table_low_level_anxiety_mental_reference.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TabMental extends GetView<VerifyTestParamsController> {
  const TabMental({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 3,
        child: VStack(
          [
            'Skor'.text.xl4.semiBold.make(),
            (controller.verifyDetail.value.totalScatScore ?? '-')
                .text
                .xl6
                .semiBold
                .green500
                .make(),
            UiSpacer.verticalSpace(space: 10),
            TextFormField(
              controller: controller.mentalScore,
              validator: (value) {
                if (value.isEmptyOrNull) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: const InputDecoration(labelText: 'Rating Nilai'),
            ),
            UiSpacer.verticalSpace(),
            'Referensi Nilai'.text.semiBold.xl.make(),
            UiSpacer.verticalSpace(),
            TabBar(tabs: [
              Tab(
                height: 50,
                child: VStack(
                  [
                    '1-16'.text.make(),
                    'Low Level Anxiety'.text.sm.center.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ),
              Tab(
                height: 50,
                child: VStack(
                  [
                    '17-24'.text.make(),
                    'Average Level Anxiety'.text.sm.center.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ),
              Tab(
                height: 50,
                child: VStack(
                  [
                    '> 25'.text.make(),
                    'High Level Anxiety'.text.sm.center.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ),
              ),
            ]),
            UiSpacer.verticalSpace(),
            const TabBarView(children: [
              TableLowLevelAnxietyMentalReference(),
              TableAverageLevelAnxietyMentalReference(),
              TableHighLevelAnxietyMentalReference(),
            ]).expand(),
          ],
          crossAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
