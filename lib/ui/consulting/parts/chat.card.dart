import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatCard extends StatelessWidget {
  final Message message;
  final User currentUser;
  const ChatCard({Key? key, required this.message, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        HStack([
          (message.sender?.name ?? 'Sistem').text.semiBold.sm.make(),
          UiSpacer.horizontalSpace(space: 10),
        ]).expand(),
        (message.formatHourOnly).text.sm.gray500.make()
      ]),
      UiSpacer.verticalSpace(space: 5),
      HtmlWidget(
        message.message ?? '',
        onTapUrl: (url) => message.openLink(url),
        isSelectable: true,
        textStyle: const TextStyle(
          fontSize: 12,
        ),
        enableCaching: true,
      ),
    ])
        .p12()
        .box
        .color(memberChatBgColor)
        .margin(message.isSender(currentUser) == true
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30))
        .roundedSM
        .make()
        .py4();
  }
}
