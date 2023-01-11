import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/scouting/controller/coach_scouting_history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ScoutingCoachHistory extends GetView<CoachScoutingHistoryController> {
  static const routeName = '/scouting/coach/history';
  const ScoutingCoachHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachScoutingHistoryController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Riwayat Penawaran Pelatih'.text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          enablePullDown: true,
          enablePullUp: true,
          child: ListView.builder(
              itemCount: controller.offerings.value.data?.length ?? 0,
              itemBuilder: (context, index) {
                final offer = controller.offerings.value.data?[index];
                return HStack([
                  VStack(
                    [
                      CachedNetworkImage(
                        imageUrl: offer?.employee?.photo == null
                            ? offer!.employee!.gravatar()
                            : offer!.employee!.photo!,
                        fit: BoxFit.cover,
                      ).wh(75, 75).cornerRadius(80),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                  UiSpacer.horizontalSpace(),
                  VStack(
                    [
                      (offer.employee?.name ?? '-')
                          .text
                          .lg
                          .ellipsis
                          .semiBold
                          .make(),
                      if (offer.offeringPositions != null)
                        offer.offeringPositions!
                            .map((e) => (e.position?.name ?? '-'))
                            .join(', ')
                            .text
                            .sm
                            .make(),
                    ],
                    alignment: MainAxisAlignment.start,
                    crossAlignment: CrossAxisAlignment.start,
                  ).expand(),
                  offer.status?.id == 0
                      ? 'Batal'
                          .text
                          .white
                          .make()
                          .p8()
                          .card
                          .color(primaryColor)
                          .make()
                          .onInkTap(() => controller.cancelOfferingCoach(offer))
                      : (offer.status?.name ?? '-')
                          .text
                          .semiBold
                          .color(offer.statusColor)
                          .make()
                ])
                    .p8()
                    .onInkTap(() => controller.openDetailCoach(offer.employee));
              }),
        ).p12(),
      ),
    );
  }
}
