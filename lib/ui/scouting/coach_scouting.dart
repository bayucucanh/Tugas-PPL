import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/scouting/controller/coach_scouting.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachScouting extends GetView<CoachScoutingController> {
  static const routeName = '/scouting/coach';
  const CoachScouting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachScoutingController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Coach Scouting'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.getHistory,
            icon: const Icon(Icons.work_history_rounded)),
        IconButton(
          onPressed: controller.getClubCoachHistory,
          icon: const Icon(Icons.transfer_within_a_station_rounded),
          tooltip: 'Riwayat Penawaran Klub Pelatih',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TextFormComponent(
          controller: controller.search,
          textInputAction: TextInputAction.search,
          validator: (val) {
            return null;
          },
          suffixIcon: IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.search),
          ),
          label: 'Cari ID pelatih atau nama pelatih',
        ).p12(),
      ),
      body: SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          primary: true,
          child: Obx(() => controller.coaches.value.data!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada pelatih',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemExtent: 110,
                  itemCount: controller.coaches.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final coach =
                        controller.coaches.value.data?[index].employee;
                    return HStack([
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                            coach?.photo == null
                                ? coach!.gravatar()
                                : coach!.photo!),
                      ),
                      UiSpacer.horizontalSpace(space: 10),
                      VStack([
                        (coach.name ?? '-')
                            .text
                            .semiBold
                            .maxLines(2)
                            .ellipsis
                            .make(),
                        (coach.age ?? '').text.sm.make(),
                        (coach.nationality?.name ?? '').text.sm.make(),
                        (coach.city?.name?.capitalize ?? '').text.sm.make(),
                        (coach.clubCoach?.club?.name ?? '').text.sm.make(),
                      ]).expand(),
                    ]).p8().onInkTap(() => controller
                        .getDetail(controller.coaches.value.data?[index]));
                  })).p12()),
    );
  }
}
