import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class FileForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final FileObservable? selectedFile;
  final bool? enable;
  final String label;
  final void Function()? onTap;
  const FileForm({
    Key? key,
    this.validator,
    this.selectedFile,
    this.enable,
    this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      label.text.semiBold.lg.make(),
      UiSpacer.verticalSpace(space: 5),
      TextFormField(
        validator: validator,
        style: const TextStyle(
          color: primaryColor,
        ),
        decoration: InputDecoration(
          hintText: selectedFile?.name ?? 'Pilih File',
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: const Icon(Icons.folder_open_rounded),
        ),
        onTap: enable == true ? onTap : null,
        enabled: enable,
        readOnly: true,
      )
    ]);
  }
}
