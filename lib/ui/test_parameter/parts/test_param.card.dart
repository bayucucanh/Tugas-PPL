import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TestParamCard extends StatelessWidget {
  final PerformanceTestVerification verifyParams;
  const TestParamCard({Key? key, required this.verifyParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack(
        [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                verifyParams.player?.photo == null
                    ? verifyParams.player!.gravatar()
                    : verifyParams.player!.photo!),
          ).wh(75, 75),
          UiSpacer.horizontalSpace(space: 5),
          VStack(
            [
              (verifyParams.player?.name ?? '-')
                  .text
                  .semiBold
                  .make(),
              HStack([
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                ),
                UiSpacer.horizontalSpace(space: 5),
                (verifyParams.formatCreatedAt).text.sm.gray500.make(),
              ]),
              HStack([
                (verifyParams.status?.id == 1
                        ? 'Belum Diverifikasi'
                        : verifyParams.status?.name ?? '-')
                    .text
                    .sm
                    .color(verifyParams.status!.getStatusColor()!)
                    .make(),
                UiSpacer.horizontalSpace(space: 5),
                (verifyParams.moment ?? '-').text.sm.gray500.make(),
              ]),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ).expand(),
        ],
        alignment: MainAxisAlignment.start,
      ),
    ]);
  }
}
