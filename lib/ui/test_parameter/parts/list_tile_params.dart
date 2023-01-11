import 'package:flutter/material.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ListTileParams extends StatelessWidget {
  final String label;
  final String result;
  final Function()? onTapVideo;
  final Function()? onTap;
  final TextEditingController? controller;
  final bool? isEdit;
  const ListTileParams(
      {Key? key,
      required this.label,
      required this.result,
      required this.onTapVideo,
      this.isEdit = false,
      this.onTap,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: label.text.make(),
      subtitle: isEdit == false
          ? 'Hasil : $result'.text.make()
          : VStack([
              'Hasil : $result'.text.make(),
              UiSpacer.horizontalSpace(space: 10),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: result.toString(),
                ),
                validator: (value) {
                  if (int.tryParse(value!)! > 100) {
                    return 'Nilai tidak boleh lebih dari 100.';
                  }

                  if (int.tryParse(value)! < 0) {
                    return 'Nilai tidak boleh lebih dari 0.';
                  }
                  return null;
                },
              ),
            ]),
      trailing: const Icon(Icons.link).onTap(onTapVideo),
      onTap: onTap,
    );
  }
}
