import 'package:flutter/material.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class BottomSheetComponent extends StatelessWidget {
  final Widget? child;
  final Color bgColor;
  const BottomSheetComponent({
    Key? key,
    this.child,
    this.bgColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      const Divider(
        indent: 150,
        endIndent: 150,
        thickness: 3,
        height: 20,
      ),
      child ?? UiSpacer.emptySpace(),
    ])
        .box
        .color(bgColor)
        .p12
        .topRounded(value: 40)
        .withConstraints(const BoxConstraints(
          minHeight: 100,
          maxHeight: 700,
        ))
        .make();
  }
}
