import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/verify_task/controller/verify_video.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CommentSection extends GetView<VerifyVideoController> {
  const CommentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Skor'.text.semiBold.xl.make(),
      UiSpacer.verticalSpace(space: 5),
      TextFormField(
        controller: controller.score,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
        ),
        keyboardType: TextInputType.number,
      ),
      UiSpacer.verticalSpace(),
      'Komentar'.text.semiBold.xl.make(),
      UiSpacer.verticalSpace(),
      TextFormField(
        controller: controller.commentTx,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        minLines: 4,
        maxLines: 6,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      UiSpacer.verticalSpace(),
      HStack(
        [
          'Tolak'
              .text
              .color(primaryColor)
              .makeCentered()
              .continuousRectangle(
                  width: 120,
                  height: 40,
                  backgroundColor: Colors.white,
                  borderSide: const BorderSide(color: primaryColor))
              .onTap(controller.deniedDialog)
              .centered(),
          'Terima'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                width: 120,
                height: 40,
                backgroundColor: primaryColor,
              )
              .onTap(controller.acceptDialog)
              .centered(),
        ],
        alignment: MainAxisAlignment.spaceEvenly,
        axisSize: MainAxisSize.max,
      )
    ]).p12();
  }
}
