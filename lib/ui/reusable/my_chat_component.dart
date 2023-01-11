import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class MyChatComponent extends StatelessWidget {
  final Message message;
  final bool? showBadge;
  const MyChatComponent({
    Key? key,
    required this.message,
    this.showBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        HStack([
          'Saya'.text.semiBold.make(),
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
    ]).p12().box.color(myChatColor).roundedSM.make().p4().marginOnly(left: 20);
  }
}
