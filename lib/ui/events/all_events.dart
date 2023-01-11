import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/events/controller/all_event.controller.dart';
import 'package:mobile_pssi/ui/events/parts/event.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class AllEvents extends GetView<AllEventController> {
  static const routeName = '/events/all';
  const AllEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AllEventController());
    return DefaultScaffold(
      title: 'Semua Event'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.events!.isEmpty
              ? 'Event belum tersedia'.text.makeCentered()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.events?.length ?? 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemExtent: 155,
                  itemBuilder: (context, index) {
                    final event = controller.events?[index];
                    return EventCard(
                      data: event!,
                      onTap: () => controller.openDetail(event),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
