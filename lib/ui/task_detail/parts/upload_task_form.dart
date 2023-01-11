import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/task_detail/controller/task_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class UploadTaskForm extends GetView<TaskDetailController> {
  const UploadTaskForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => DottedBorder(
          color: controller.enableUpload.value ? primaryColor : Colors.grey,
          dashPattern: const [10],
          child: VStack(
            [
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
                            .onTap(() => controller.selectFile(
                                source: ImageSource.camera)),
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
                            .onTap(() => controller.selectFile(
                                source: ImageSource.gallery)),
                      ],
                      alignment: MainAxisAlignment.spaceEvenly,
                      axisSize: MainAxisSize.max,
                      crossAlignment: CrossAxisAlignment.center,
                    ),
              UiSpacer.verticalSpace(),
              'Kirim Ulang'
                  .text
                  .white
                  .makeCentered()
                  .box
                  .color(controller.isUploading.value == false &&
                          controller.enableUpload.value
                      ? primaryColor
                      : Colors.grey)
                  .p12
                  .roundedSM
                  .make()
                  .onInkTap(controller.isUploading.value == false &&
                          controller.enableUpload.value
                      ? controller.confirmUploadVideo
                      : null)
            ],
            alignment: MainAxisAlignment.spaceAround,
            crossAlignment: CrossAxisAlignment.center,
            axisSize: MainAxisSize.max,
          ).p12(),
        ).p12());
  }
}
