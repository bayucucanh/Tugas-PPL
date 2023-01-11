import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/performance_test.dart';
import 'package:mobile_pssi/extensions/test_parameter.extension.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailChart extends StatelessWidget {
  final String title;
  final List<PerformanceTest>? performanceTests;
  const DetailChart({
    Key? key,
    required this.title,
    this.performanceTests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      title.text.semiBold.makeCentered(),
      UiSpacer.verticalSpace(space: 10),
      performanceTests == null || performanceTests!.isEmpty
          ? 'Belum ada test parameter'.text.sm.center.makeCentered()
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final performanceTest = performanceTests?[index];
                return HStack([
                  (performanceTest?.performanceItem?.name ?? '-')
                      .text
                      .sm
                      .make()
                      .expand(),
                  (performanceTest?.actualScore ?? 0)
                      .text
                      .semiBold
                      .color(performanceTest?.actualScore?.getNumberColor())
                      .make()
                ]);
              },
              itemCount: performanceTests?.length ?? 0,
            ),
    ]).p12().card.make();
  }
}
