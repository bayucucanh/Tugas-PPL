import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class MentalTab extends StatelessWidget {
  final PerformanceTestVerification? performanceTestVerification;
  const MentalTab({
    Key? key,
    this.performanceTestVerification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        'Skor'.text.xl4.semiBold.make(),
        '${performanceTestVerification?.scatScore ?? '-'}'
            .text
            .xl6
            .semiBold
            .green500
            .make(),
        UiSpacer.verticalSpace(),
        (performanceTestVerification?.anxietyDescription ?? '-').text.make(),
      ],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
      axisSize: MainAxisSize.max,
    );
  }
}
