import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/competitions/controller/all_competition.controller.dart';
import 'package:mobile_pssi/ui/events/parts/event.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class AllCompetition extends GetView<AllCompetitionController> {
  static const routeName = '/competitions/all';
  const AllCompetition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AllCompetitionController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Semua Kompetisi'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.events!.isEmpty
              ? 'Kompetisi belum tersedia'.text.makeCentered()
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
