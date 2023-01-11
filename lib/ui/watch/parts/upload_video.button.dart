import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/watch/controller/upload_video.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class UploadVideoButton extends GetView<UploadVideoController> {
  final int learningTaskId;
  const UploadVideoButton({
    Key? key,
    required this.learningTaskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack(
        [
          const Icon(
            Icons.videocam_rounded,
            color: primaryColor,
            size: 48,
          ).centered(),
          UiSpacer.verticalSpace(),
          ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            selectedColor: Colors.white,
            selectedBorderColor: primaryColor,
            fillColor: primaryColor,
            isSelected: controller.toggleSelecteds.toList(),
            onPressed: (value) => controller.changeUploadType(value),
            children: [
              'Link Youtube'.text.make().p8(),
              'Upload Video'.text.make().p8(),
            ],
          ).h(40).centered(),
          UiSpacer.verticalSpace(space: 10),
          controller.isYoutubeLink.value
              ? TextFormField(
                  controller: controller.youtubeLink,
                  decoration: InputDecoration(
                      hintText: 'https://youtu.be/xxxx',
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.ondemand_video_rounded,
                          color: primaryColor,
                        ),
                        onPressed: () {},
                      )),
                )
              : HStack(
                  [
                    HStack([
                      UiSpacer.horizontalSpace(space: 5),
                      const Icon(
                        Icons.camera_alt_rounded,
                        color: Vx.white,
                      ),
                      UiSpacer.horizontalSpace(space: 5),
                      'Rekam'.text.white.makeCentered(),
                    ])
                        .continuousRectangle(
                          backgroundColor: primaryColor,
                          width: 90,
                          height: 40,
                        )
                        .onTap(() =>
                            controller.selectFile(source: ImageSource.camera)),
                    UiSpacer.divider(height: 40, thickness: 10),
                    HStack([
                      UiSpacer.horizontalSpace(space: 5),
                      const Icon(
                        Icons.browse_gallery_rounded,
                        color: Vx.white,
                      ),
                      UiSpacer.horizontalSpace(space: 5),
                      'Galeri'.text.white.makeCentered(),
                    ])
                        .continuousRectangle(
                          backgroundColor: primaryColor,
                          width: 90,
                          height: 40,
                        )
                        .onTap(() =>
                            controller.selectFile(source: ImageSource.gallery)),
                  ],
                  alignment: MainAxisAlignment.spaceEvenly,
                  axisSize: MainAxisSize.max,
                  crossAlignment: CrossAxisAlignment.center,
                ),
          UiSpacer.verticalSpace(),
          'Submit Tugas'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                  height: 40,
                  backgroundColor: controller.isLoading.value == false &&
                          controller.enableUpload.value
                      ? primaryColor
                      : Colors.grey)
              .onTap(controller.isLoading.value == false &&
                      controller.enableUpload.value
                  ? () => controller.uploadFile(learningTaskId)
                  : null),
        ],
      ),
    );
  }
}
