import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageUpload extends FormField<FileObservable> {
  ImageUpload({
    Key? key,
    required BuildContext context,
    initialValue,
    onChange,
    String? selectLabel,
    String? changeLabel,
    String? placeholder,
    String? blurhash,
    required FormFieldSetter<FileObservable> onSaved,
    required FormFieldValidator<FileObservable> validator,
    enabled = true,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            enabled: enabled,
            initialValue: initialValue,
            builder: (FormFieldState<FileObservable> state) {
              return VStack([
                DottedBorder(
                  color: primaryColor,
                  dashPattern: const [10],
                  child: state.value?.name == null
                      ? VStack([
                          placeholder != null
                              ? ImageCustom(url: placeholder, blurhash: blurhash)
                                  .wFull(context)
                                  .h(180)
                              : const Icon(
                                  Icons.image,
                                  size: 120,
                                  color: primaryColor,
                                ).wFull(context).h(180),
                          (selectLabel ?? 'Pilih Gambar')
                              .text
                              .white
                              .makeCentered()
                              .p12()
                              .box
                              .color(primaryColor)
                              .make(),
                        ])
                      : VStack([
                          Image.file(
                            state.value!.toFile,
                            fit: BoxFit.cover,
                          ).wFull(context).h(180),
                          (changeLabel ?? 'Ubah Gambar')
                              .text
                              .white
                              .makeCentered()
                              .p12()
                              .box
                              .color(primaryColor)
                              .make(),
                        ]),
                ).onInkTap(() {
                  selectFile(state);
                }),
                if (state.errorText != null)
                  VStack([
                    UiSpacer.verticalSpace(space: 5),
                    (state.errorText ?? '').text.red600.sm.make(),
                  ]),
              ]);
            });

  static selectFile(FormFieldState<FileObservable> state) async {
    FilePickerResult? select = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      allowedExtensions: ['png', 'jpg'],
      type: FileType.custom,
    );

    if (select != null) {
      state.didChange(FileObservable.filePickerResult(select));
    }
  }
}
