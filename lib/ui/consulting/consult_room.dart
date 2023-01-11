import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/consulting/controller/consult_room.controller.dart';
import 'package:mobile_pssi/ui/consulting/parts/chat.card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:velocity_x/velocity_x.dart';

class ConsultRoom extends GetView<ConsultRoomController> {
  static const routeName = '/consult/room';
  const ConsultRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ConsultRoomController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        centerTitle: false,
        resizeToAvoidBottomInset: false,
        title: HStack(
          [
            if (controller.consultationDetail?.consultWith?.imageProfile ==
                null)
              CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                    controller.consultationDetail!.consultWith!.imageProfile),
              ),
            UiSpacer.horizontalSpace(space: 10),
            (controller.consultationDetail?.consultWith?.profile?.name ?? '-')
                .text
                .sm
                .ellipsis
                .maxLines(1)
                .make(),
          ],
          axisSize: MainAxisSize.min,
          crossAlignment: CrossAxisAlignment.center,
          alignment: MainAxisAlignment.start,
        ),
        actions: [
          if (controller.consultationDetail?.status?.id == 1 &&
              controller.userData.value.isCoach)
            TextButton(
                onPressed: controller.endDialog, child: 'Selesai'.text.make()),
        ],
        bottom: controller.consultationDetail?.status?.id != 1 ||
                controller.consultationDetail!.expiredInMinute!.isNegative
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: SlideCountdown(
                  duration: controller.consultationDetail!.expiredInMinute!,
                  decoration: const BoxDecoration(),
                  onDone: controller.consultationDetail?.status?.id != 1 ||
                          controller
                              .consultationDetail!.expiredInMinute!.isNegative
                      ? null
                      : controller.timerExpired,
                )),
        body: VStack(
          [
            SmartRefresher(
              scrollController: controller.scrollController,
              controller: controller.refreshController,
              onLoading: controller.loadMore,
              onRefresh: controller.refreshData,
              enablePullDown: true,
              enablePullUp: true,
              child: controller.chats!.isEmpty
                  ? 'Belum ada pesan'.text.makeCentered()
                  : GroupedListView<Message, DateTime>(
                      sort: false,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      useStickyGroupSeparators: true,
                      stickyHeaderBackgroundColor: Get.theme.backgroundColor,
                      elements: controller.chats!,
                      groupSeparatorBuilder: (DateTime? groupByValue) =>
                          DateFormat('dd MMMM yyyy').format(DateTime.now()) ==
                                  DateFormat('dd MMMM yyyy')
                                      .format(groupByValue!)
                              ? 'Hari Ini'.text.semiBold.center.make()
                              : DateFormat('dd MMMM yyyy', 'id_ID')
                                  .format(groupByValue)
                                  .text
                                  .center
                                  .semiBold
                                  .make()
                                  .p8(),
                      itemBuilder: (context, Message message) => ChatCard(
                          message: message,
                          currentUser: controller.userData.value),
                      groupComparator: (DateTime item1, DateTime item2) =>
                          DateFormat('dd MMMM yyyy').format(item1).compareTo(
                              DateFormat('dd MMMM yyyy').format(item2)),
                      groupBy: (Message message) => DateTime(
                          message.createdAt!.year,
                          message.createdAt!.month,
                          message.createdAt!.day),
                    ).p8(),
            ).expand(),
            controller.consultationDetail?.status?.id == 1
                ? HStack(
                    [
                      TextFormField(
                        controller: controller.chatMessage,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 140,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Aa',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Vx.gray200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                          counter: UiSpacer.emptySpace(),
                        ),
                        cursorRadius: const Radius.circular(20),
                        cursorColor: primaryColor,
                        style: const TextStyle(fontSize: 14),
                      ).expand(),
                      UiSpacer.horizontalSpace(space: 5),
                      IconButton(
                        onPressed: controller.isSendingMessage.value
                            ? null
                            : controller.chatCoach,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      )
                          .centered()
                          .box
                          .color(controller.isSendingMessage.value
                              ? Colors.grey
                              : primaryColor)
                          .roundedLg
                          .make(),
                    ],
                    alignment: MainAxisAlignment.center,
                    axisSize: MainAxisSize.max,
                  )
                    .box
                    .withConstraints(const BoxConstraints(
                      minHeight: 80,
                    ))
                    .make()
                : UiSpacer.emptySpace()
          ],
        ).p12(),
      ),
    );
  }
}
