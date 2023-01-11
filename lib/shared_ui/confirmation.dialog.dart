import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ConfirmationDefaultDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final String cancelText;
  final String confirmText;
  final bool? showCancel;
  final Function()? onCancel;
  final Function()? onConfirm;
  final bool? showConfirm;
  final Color confirmColor;

  const ConfirmationDefaultDialog({
    Key? key,
    this.title = 'Alert',
    this.content,
    this.contentWidget,
    this.cancelText = 'Tidak',
    this.showCancel = true,
    this.onCancel,
    this.onConfirm,
    this.confirmText = 'Ya',
    this.showConfirm = true,
    this.confirmColor = primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack([
        title.text.semiBold.lg.makeCentered(),
        UiSpacer.verticalSpace(),
        if (contentWidget != null) contentWidget!,
        if (content != null) content!.text.make(),
        UiSpacer.verticalSpace(),
        HStack(
          [
            if (showCancel == true)
              cancelText.text
              .center
                  .color(primaryColor)
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    width: 120,
                    backgroundColor: Colors.transparent,
                    borderSide: const BorderSide(color: primaryColor),
                  )
                  .onInkTap(onCancel ?? () => Get.back()),
            if (showConfirm == true)
              confirmText.text.white
              .center
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    width: 120,
                    backgroundColor: confirmColor,
                  )
                  .onInkTap(onConfirm),
          ],
          alignment: MainAxisAlignment.spaceBetween,
          crossAlignment: CrossAxisAlignment.center,
          axisSize: MainAxisSize.max,
        )
      ]).p12(),
    );
  }
}
