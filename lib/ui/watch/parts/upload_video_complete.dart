import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class UploadVideoComplete extends StatelessWidget {
  const UploadVideoComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      const Icon(
        Icons.videocam_rounded,
        color: primaryColor,
        size: 48,
      ).centered(),
      UiSpacer.verticalSpace(),
      'Lihat Tugas'.text.color(primaryColor).makeCentered()
    ]);
  }
}
