import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EventCard extends StatelessWidget {
  final Event data;
  final Function() onTap;
  const EventCard({Key? key, required this.data, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        ImageCustom(
          url: data.banner!,
          blurhash: data.blurhash,
        ).wh(200, 120).cornerRadius(10),
        UiSpacer.verticalSpace(space: 10),
        (data.name ?? '-').text.bold.make(),
        UiSpacer.verticalSpace(space: 10),
        (data.startDateFormat ?? '-').text.bold.xs.make(),
        UiSpacer.verticalSpace(space: 5),
        (data.additionalDescription ?? '-')
            .text
            .ellipsis
            .xs
            .maxLines(1)
            .make()
            .expand(),
        UiSpacer.verticalSpace(space: 10),
        (data.priceFormat ?? '-').text.color(primaryColor).semiBold.make()
      ],
    ).marginOnly(right: 20).onTap(onTap);
  }
}
