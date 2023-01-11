import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/data/model/performance_form.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PerformanceFormField extends StatelessWidget {
  final PerformanceForm performanceForm;
  const PerformanceFormField({
    Key? key,
    required this.performanceForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      (performanceForm.performanceItem?.name ?? '-').text.semiBold.make(),
      HStack([
        if (performanceForm.performanceItem?.inputType == 'link_with_value')
          HStack([
            TextFormField(
              controller: performanceForm.scoreText,
              decoration: InputDecoration(
                errorMaxLines: 4,
                hintText: performanceForm.performanceItem?.minValue != null &&
                        performanceForm.performanceItem?.maxValue != null
                    ? '${performanceForm.performanceItem?.minValue} - ${performanceForm.performanceItem?.maxValue}'
                    : 'Hasil',
                helperText: performanceForm.performanceItem?.unitHint,
                helperStyle: const TextStyle(
                  fontSize: 11,
                ),
              ),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong.';
                }
                if (performanceForm.performanceItem?.maxValue == null) {
                  if (int.tryParse(value)! > 100) {
                    return 'Nilai tidak boleh lebih dari 100.';
                  }
                } else {
                  if (int.tryParse(value)! >
                      performanceForm.performanceItem!.maxValue!) {
                    return 'Nilai tidak boleh lebih dari ${performanceForm.performanceItem?.maxValue}.';
                  }
                }

                if (performanceForm.performanceItem?.minValue == null) {
                  if (int.tryParse(value)! < 0) {
                    return 'Nilai tidak boleh kurang dari 0.';
                  }
                } else {
                  if (int.tryParse(value)! <
                      performanceForm.performanceItem!.minValue!) {
                    return 'Nilai tidak boleh kurang dari ${performanceForm.performanceItem?.minValue}.';
                  }
                }

                return null;
              },
            ).w(70),
            UiSpacer.horizontalSpace(),
          ]),
        Obx(
          () => TextFormField(
            controller: performanceForm.linkText,
            keyboardType: TextInputType.url,
            readOnly:
                performanceForm.fileVideo?.value.path == null ? false : true,
            validator: (value) {
              if (performanceForm.fileVideo?.value.path == null) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong.';
                }
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: performanceForm.fileVideo?.value.path != null
                  ? 'File video dipilih.'
                  : 'Link Video',
              isDense: true,
              suffixIcon: HStack(
                [
                  IconButton(
                    onPressed: () =>
                        performanceForm.selectFile(source: ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded),
                  ),
                  IconButton(
                    onPressed: () =>
                        performanceForm.selectFile(source: ImageSource.gallery),
                    icon: const Icon(Icons.browse_gallery_rounded),
                  ),
                ],
              ),
              helperText: 'Masukan link video atau upload file video',
            ),
          ).expand(),
        ),
      ]),
    ]).py12();
  }
}
