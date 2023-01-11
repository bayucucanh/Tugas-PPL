import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/watch/controller/watch.controller.dart';
import 'package:mobile_pssi/ui/watch/parts/upload_video.button.dart';
import 'package:mobile_pssi/ui/watch/parts/upload_video_complete.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PracticeUpload extends GetView<WatchController> {
  const PracticeUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.currentVideo == null
          ? 'Kelas belum tersedia tugas atau video'.text.makeCentered()
          : controller.currentVideo!.isTask!.contains("Tidak")
              ? 'Video ini tidak berisi tugas praktek'
                  .text
                  .semiBold
                  .xl
                  .gray500
                  .makeCentered()
              : controller.currentVideo?.learningTask != null ||
                      controller.uploadVideo.uploaded.value == true
                  ? VStack([
                      'Detil Tugas'.text.semiBold.xl.make(),
                      UiSpacer.verticalSpace(),
                      InkWell(
                        onTap: () => controller.uploadVideo.openDetailVideo(
                            controller.currentVideo?.learningTask ??
                                controller.uploadVideo.uploadedData.value),
                        child: DottedBorder(
                          padding: const EdgeInsets.all(20),
                          color: controller.uploadVideo.youtubeLink.isBlank ==
                                  false
                              ? primaryColor
                              : Colors.grey,
                          dashPattern: const [8],
                          radius: const Radius.circular(20),
                          child: const UploadVideoComplete(),
                        ).centered(),
                      ),
                    ]).p12().scrollVertical()
                  : VStack([
                      'Upload Video'.text.semiBold.xl.make(),
                      UiSpacer.verticalSpace(),
                      DottedBorder(
                        padding: const EdgeInsets.all(20),
                        color: controller.uploadVideo.enableUpload.value
                            ? primaryColor
                            : Colors.grey,
                        dashPattern: const [8],
                        radius: const Radius.circular(20),
                        child: UploadVideoButton(
                            learningTaskId: controller.currentVideo!.id!),
                      ),
                    ]).p12().scrollVertical(),
    );
  }
}
