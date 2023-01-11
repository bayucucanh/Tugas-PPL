import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyWithButton extends StatelessWidget {
  final String emptyMessage;
  final String? textButton;
  final Function()? onTap;
  final bool? showButton;
  final bool? showImage;
  const EmptyWithButton({
    Key? key,
    required this.emptyMessage,
    this.textButton,
    this.onTap,
    this.showButton = true,
    this.showImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        if (showImage == true)
          VStack(
            [
              SvgPicture.asset('assets/images/undraw_junior_soccer_6sop.svg')
                  .h(150),
              UiSpacer.verticalSpace(),
            ],
          ),
        emptyMessage.text.center.makeCentered(),
        UiSpacer.verticalSpace(),
        if (showButton == true)
          (textButton ?? 'Tambah')
              .text
              .white
              .center
              .makeCentered()
              .continuousRectangle(
                height: 40,
                width: 200,
                backgroundColor: primaryColor,
              )
              .onInkTap(onTap)
              .centered()
      ],
      alignment: MainAxisAlignment.center,
      axisSize: MainAxisSize.max,
      crossAlignment: CrossAxisAlignment.center,
    );
  }
}
