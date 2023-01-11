import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/extensions/numeral.extension.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoCard extends StatelessWidget {
  final Class classDetail;
  final VideoModel? video;
  final int number;
  final Function()? onTap;
  final Function(bool?)? checked;
  final bool? currentWatch;
  const VideoCard({
    Key? key,
    required this.classDetail,
    required this.video,
    required this.number,
    this.checked,
    this.onTap,
    this.currentWatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: VStack([
        HStack([
          '${classDetail.name} #$number - ${video?.name ?? '-'}'
              .text
              .color(currentWatch == true ? Colors.white : Colors.black)
              .make()
              .expand(),
          if (video != null)
            Checkbox(
              value: video?.checkedVideo,
              onChanged: checked,
              activeColor: primaryColor,
              splashRadius: 10,
            )
        ]),
        UiSpacer.verticalSpace(space: 5),
        HStack([
          '${video?.totalView!.numeral() ?? '0'} views'
              .text
              .sm
              .color(currentWatch == true ? Colors.white : Colors.grey)
              .make(),
          UiSpacer.horizontalSpace(space: 5),
        ]),
      ])
          .box
          .p4
          .color(
            currentWatch == true
                ? primaryColor.withOpacity(0.6)
                : Colors.transparent,
          )
          .roundedSM
          .make(),
    );
  }
}
