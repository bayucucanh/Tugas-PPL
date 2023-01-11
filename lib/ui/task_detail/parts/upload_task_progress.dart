// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_pssi/constant/colors.dart';
// import 'package:mobile_pssi/ui/task_detail/controller/task_detail.controller.dart';
// import 'package:mobile_pssi/utils/ui.spacer.dart';
// import 'package:velocity_x/velocity_x.dart';

// class UploadTaskProgress extends GetView<TaskDetailController> {
//   const UploadTaskProgress({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => DottedBorder(
//         color: primaryColor,
//         dashPattern: const [10],
//         child: HStack(
//           [
//             const Icon(
//               Icons.videocam_rounded,
//               color: primaryColor,
//               size: 48,
//             ),
//             UiSpacer.horizontalSpace(space: 10),
//             VStack([
//               (controller.videoFilename ?? '-')
//                   .text
//                   .color(primaryColor)
//                   .makeCentered(),
//               HStack([
//                 '${controller.textProgress}%'.text.xs.make().expand(),
//                 '100%'.text.xs.make(),
//               ]),
//               LinearProgressIndicator(
//                 backgroundColor: primaryColor.withOpacity(0.5),
//                 color: primaryColor,
//                 value: controller.progress.value,
//                 minHeight: 10,
//               ).cornerRadius(20)
//             ]).expand()
//           ],
//           alignment: MainAxisAlignment.spaceAround,
//           crossAlignment: CrossAxisAlignment.center,
//           axisSize: MainAxisSize.max,
//         ).p12(),
//       ).p12(),
//     );
//   }
// }
