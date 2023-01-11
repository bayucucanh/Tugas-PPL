import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class OpponentChatComponent extends StatelessWidget {
  final Message message;
  final bool? showBadge;
  const OpponentChatComponent({
    Key? key,
    required this.message,
    this.showBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        HStack([
          (message.sender?.name ?? 'Tidak Diketahui').text.semiBold.make(),
          UiSpacer.horizontalSpace(space: 5),
          if (showBadge == true)
            const Icon(
              Icons.check_circle_rounded,
              color: officialCheckColor,
              size: 12,
            ),
        ]).expand(),
        (message.formatHourOnly).text.xs.gray500.make(),
      ]),
      UiSpacer.verticalSpace(space: 10),
      (message.message ?? '').text.make(),
    ])
        .p12()
        .box
        .color(opponentColor)
        .roundedSM
        .make()
        .p4()
        .marginOnly(right: 20);
  }
}
