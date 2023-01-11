import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ConsultDialog extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? onTap;
  const ConsultDialog({Key? key, this.controller, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack([
        'Konsultasi'.text.center.xl.semiBold.makeCentered(),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Pesan Konsultasi',
            labelText: 'Pesan Konsultasi',
          ),
          minLines: 3,
          maxLines: 3,
        ),
        ElevatedButton(onPressed: onTap, child: 'Submit'.text.make())
            .objectCenterRight(),
      ]).p12(),
    );
  }
}
