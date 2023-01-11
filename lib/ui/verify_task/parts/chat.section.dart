import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/reusable/my_chat_component.dart';
import 'package:mobile_pssi/ui/reusable/opponent_chat_component.dart';
import 'package:mobile_pssi/ui/verify_task/controller/verify_video.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatSection extends GetView<VerifyVideoController> {
  const ChatSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
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
                            ? MyChatComponent(
                                message: message,
                                showBadge: true,
                              )
                            : OpponentChatComponent(message: message);
                      },
                    ),
        )
      ]).p12().scrollVertical(),
    );
  }
}
