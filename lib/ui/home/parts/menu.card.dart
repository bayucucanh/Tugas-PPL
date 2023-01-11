import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;
  const MenuCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      Icon(
        icon,
        color: primaryColor,
        size: 28,
      ).centered(),
      UiSpacer.verticalSpace(space: 10),
      label.text.semiBold.center.sm.makeCentered(),
    ]).onTap(onTap);
  }
}
