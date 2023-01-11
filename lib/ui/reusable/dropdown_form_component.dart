import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/border_radius.dart';
import 'package:mobile_pssi/constant/box_shadow.dart';

class DropdownFormComponent extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem> items;
  final Function(dynamic)? onChanged;
  final bool isRequired;
  final dynamic value;
  final String Function(dynamic) validator;

  const DropdownFormComponent({
    Key? key,
    required this.label,
    required this.items,
    this.onChanged,
    this.isRequired = false,
    required this.validator,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(circularRadius),
        boxShadow: boxShadow,
      ),
      child: DropdownButtonFormField(
        hint: Text(isRequired == true ? '$label *' : label),
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        validator: validator,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
