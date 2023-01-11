import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';

class ButtonSelectRoleComponent extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const ButtonSelectRoleComponent({Key? key, required this.label, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
