import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/video_player.spacebar.dart';
import 'package:mobile_pssi/ui/reusable/my_chat_component.dart';
import 'package:mobile_pssi/ui/reusable/opponent_chat_component.dart';
import 'package:mobile_pssi/ui/task_detail/controller/task_detail.controller.dart';
import 'package:mobile_pssi/ui/task_detail/parts/upload_task_form.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class TaskDetail extends GetView<TaskDetailController> {
  static const routeName = '/task/detail';
  const TaskDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TaskDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Detail Video'.text.make(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.black,
            collapsedHeight: 250,
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Obx(
              () => VideoPlayerSpaceBar(
                loadVideo: controller.isLoadingVideo.value,
                playerController: controller.podPlayerController,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => VStack([
                HStack([
                  VStack([
                    (controller.taskDetail.value.learningName ?? '-')
                        .text
                        .semiBold
                        .make(),
                    HStack([
                      'Status Verifikasi :'.text.gray500.make(),
                      (controller.taskDetail.value.verificationStatus ?? '-')
                          .text
                          .color(controller.taskDetail.value.getStatusColor()!)
                          .make()
                    ]),
                    HStack([
                      'Skor Tugas :'.text.gray500.make(),
                      (controller.taskDetail.value.scoreVideo
                                  ?.toDoubleStringAsFixed(digit: 0) ??
                              '-')
                          .text
                          .color(controller.taskDetail.value.getStatusColor()!)
                          .make()
                    ]),
                  ]).expand(),
                  IconButton(
                    onPressed: controller.shareTask,
                    icon: const Icon(
                      Icons.share,
                      color: primaryColor,
                    ),
                    tooltip: 'Bagikan Tugas',
                  ),
                ]),
                UiSpacer.verticalSpace(),
                if (controller.taskDetail.value.verificationStatus ==
                        'Ditolak' ||
                    controller.taskDetail.value.verificationStatus ==
                        'Diterima')
                  const UploadTaskForm(),
              ]).p12(),
            ),
          )
        ],
        body: SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: controller.refreshComments,
          onLoading: controller.loadMoreComments,
          child: VStack([
            'Komentar'.text.semiBold.xl.make(),
            Obx(
              () => controller.loadingComments.value
                  ? const CircularProgressIndicator.adaptive().centered()
                  : controller.taskComments.value.data!.isEmpty
                      ? 'Belum ada komentar'.text.gray500.italic.makeCentered()
                      : ListView.builder(
                          controller: controller.commentScroller,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.taskComments.value.data!.length,
                          itemBuilder: (context, index) {
                            final message =
                                controller.taskComments.value.data![index];
                            return controller.userData.value.id ==
                                    message.sender?.userId
                                ? MyChatComponent(message: message)
                                : OpponentChatComponent(
                                    message: message,
                                    showBadge: true,
                                  );
                          },
                        ),
            )
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
