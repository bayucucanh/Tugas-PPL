import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/notification/controller/notification.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationScreen extends GetView<NotificationController> {
  static const routeName = '/notifications';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Notifikasi'.text.semiBold.make(),
      actions: [
        TextButton(
          onPressed: controller.markAllNotification,
          child: 'Tandai Semua'.text.sm.make(),
        )
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        enablePullDown: true,
        enablePullUp: true,
        child: Obx(
          () => controller.notifications.value.data!.isEmpty
              ? 'Belum ada notifikasi'.text.makeCentered()
              : GroupedListView<Message, DateTime>(
                  sort: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  useStickyGroupSeparators: true,
                  stickyHeaderBackgroundColor: Get.theme.backgroundColor,
                  elements: controller.notifications.value.data!,
                  groupSeparatorBuilder: (DateTime? groupByValue) =>
                      DateFormat('dd MMMM yyyy').format(DateTime.now()) ==
                              DateFormat('dd MMMM yyyy').format(groupByValue!)
                          ? 'Hari Ini'.text.semiBold.make()
                          : DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(groupByValue)
                              .text
                              .semiBold
                              .make(),
                  itemBuilder: (context, Message message) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => controller.redirect(message: message),
                    leading: message.sender == null
                        ? Avatar(
                            name: 'Sistem',
                            useCache: true,
                            shape: AvatarShape.circle(30),
                          ).wh(50, 50)
                        : CircleAvatar(
                            backgroundImage: message.sender == null
                                ? null
                                : message.sender?.photoUrl == null
                                    ? CachedNetworkImageProvider(
                                        message.sender!.gravatar())
                                    : CachedNetworkImageProvider(
                                        message.sender!.photoUrl!),
                          ).wh(50, 50),
                    title: (message.sender?.name ?? 'Sistem')
                        .text
                        .semiBold
                        .sm
                        .make(),
                    subtitle: Bidi.stripHtmlIfNeeded(message.message ?? '-')
                        .text
                        .sm
                        .textStyle(TextStyle(
                          fontWeight: message.readAt == null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ))
                        .make(),
                    trailing: DateFormat('HH:mm')
                        .format(message.createdAt!)
                        .text
                        .gray500
                        .sm
                        .make(),
                  ),
                  groupComparator: (DateTime item1, DateTime item2) =>
                      DateFormat('dd MMMM yyyy')
                          .format(item1)
                          .compareTo(DateFormat('dd MMMM yyyy').format(item2)),
                  groupBy: (Message message) => DateTime(
                      message.createdAt!.year,
                      message.createdAt!.month,
                      message.createdAt!.day),
                ).p8(),
        ),
      ),
    );
  }
}
