// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_pssi/constant/colors.dart';
// import 'package:mobile_pssi/ui/watch/controller/upload_video.controller.dart';
// import 'package:mobile_pssi/utils/ui.spacer.dart';
// import 'package:velocity_x/velocity_x.dart';

// class UploadVideoProgress extends GetView<UploadVideoController> {
//   const UploadVideoProgress({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => VStack([
//         HStack([
//           const Icon(
//             Icons.videocam_rounded,
//             color: primaryColor,
//             size: 32,
//           ),
//           UiSpacer.horizontalSpace(),
//           (controller.videoFilename ?? '-').text.make(),
//         ]),
//         UiSpacer.verticalSpace(space: 10),
//         HStack([
//           '${controller.textProgress}%'.text.xs.make().expand(),
//           '100%'.text.xs.make(),
//         ]),
//         LinearProgressIndicator(
//           backgroundColor: primaryColor.withOpacity(0.5),
//           color: primaryColor,
//           value: controller.progress.value,
//           minHeight: 10,
//         ).cornerRadius(20)
//       ]),
//     );
//   }
// }
