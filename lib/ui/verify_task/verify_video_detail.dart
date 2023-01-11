import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/video_player.spacebar.dart';
import 'package:mobile_pssi/ui/verify_task/controller/verify_video.controller.dart';
import 'package:mobile_pssi/ui/verify_task/parts/chat.section.dart';
import 'package:mobile_pssi/ui/verify_task/parts/comment.section.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyVideoDetail extends GetView<VerifyVideoController> {
  static const routeName = '/task/verify/video';
  const VerifyVideoDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyVideoController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: (controller.taskDetail.value.learningTask?.learning?.name ?? '-')
            .text
            .sm
            .make(),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: Colors.black,
                    automaticallyImplyLeading: false,
                    floating: true,
                    pinned: true,
                    collapsedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: VideoPlayerSpaceBar(
                        loadVideo: controller.isLoadingVideo.value,
                        playerController: controller.podPlayerController,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: VStack([
                      (controller.taskDetail.value.learningTask?.player?.name ??
                              '-')
                          .text
                          .semiBold
                          .make(),
                      HStack([
                        'Status Verifikasi :'.text.gray500.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.taskDetail.value.status?.name ?? '-')
                            .text
                            .color(controller.taskDetail.value.status
                                ?.getStatusColor())
                            .make()
                      ]),
                      HStack([
                        'Skor :'.text.gray500.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.taskDetail.value.learningTask?.videoScore
                                    ?.toDoubleStringAsFixed(digit: 0) ??
                                'Tidak memberi skor')
                            .text
                            .color(controller.taskDetail.value.status
                                ?.getStatusColor())
                            .make()
                      ]),
                    ]).p12(),
                  )
                ],
            body: controller.taskDetail.value.status?.id == 1
                ? const CommentSection()
                : const ChatSection()),
      ),
    );
  }
}
