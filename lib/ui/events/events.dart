import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/events/controller/events.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Events extends GetView<EventsController> {
  static const routeName = '/events';
  const Events({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EventsController());
    return DefaultScaffold(
      title: 'Events'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: [
        IconButton(onPressed: controller.addEvent, icon: const Icon(Icons.add))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.events!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada event dibuat',
                showImage: true,
                onTap: controller.addEvent,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final event = controller.events?[index];
                  return Slidable(
                    key: ValueKey(event?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(event),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ImageCustom(
                      url: event!.banner!,
                      blurhash: event.blurhash,
                    )
                        .cornerRadius(20)
                        .onTap(() => controller.openDetail(event)),
                  ).p4();
                },
                itemCount: controller.events?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
