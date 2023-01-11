import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class TextFormComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool showCursor;
  final Function()? onTap;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final bool isRequired;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final bool expands;
  final String? Function(String?)? validator;

  const TextFormComponent({
    Key? key,
    this.label,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.showCursor = true,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.minLines,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.readOnly = false,
    this.isRequired = false,
    required this.textInputAction,
    required this.validator,
    this.prefixIcon,
    this.expands = false,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      expands: expands,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        hintText: isRequired == true ? '${label!} *' : label,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      style: TextStyle(
        fontSize: 14,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      minLines: minLines,
      maxLines: maxLines,
      showCursor: showCursor,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      readOnly: readOnly,
    ).box.color(Get.theme.backgroundColor).roundedSM.make();
  }
}
