import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EventCard extends StatelessWidget {
  final Event data;
  final Function()? onTap;
  const EventCard({Key? key, required this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: HStack(
        [
          ImageCustom(
            url: data.banner!,
            blurhash: data.blurhash,
          ).wh(200, 120).cornerRadius(10),
          UiSpacer.horizontalSpace(space: 10),
          VStack(
            [
              (data.name ?? '-').text.ellipsis.maxLines(2).bold.make(),
              UiSpacer.verticalSpace(space: 10),
              (data.startDateFormat ?? '-')
                  .text
                  .sm
                  .ellipsis
                  .maxLines(2)
                  .bold
                  .make(),
              UiSpacer.verticalSpace(space: 10),
              (data.additionalDescription ?? '-')
                  .text
                  .sm
                  .color(creditColor)
                  .ellipsis
                  .maxLines(4)
                  .make()
                  .expand(),
              UiSpacer.verticalSpace(space: 10),
              '${data.priceFormat ?? '-'}/org'
                  .text
                  .color(primaryColor)
                  .semiBold
                  .make(),
              'Lihat selengkapnya...'.text.blue600.sm.make(),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ).expand(),
        ],
        crossAlignment: CrossAxisAlignment.start,
      ).px4().marginOnly(top: 10),
    );
  }
}
