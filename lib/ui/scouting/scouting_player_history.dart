import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/scouting/controller/player_scouting_history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ScoutingPlayerHistory extends GetView<PlayerScoutingHistoryController> {
  static const routeName = '/scouting/player/history';
  const ScoutingPlayerHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerScoutingHistoryController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Riwayat Penawaran Pemain'.text.make(),
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_not_supported_rounded),
                        imageUrl: offer?.player?.photo == null
                            ? offer!.player!.gravatar()
                            : offer!.player!.photo!,
                        fit: BoxFit.cover,
                      ).wh(75, 75).cornerRadius(80),
                      UiSpacer.verticalSpace(space: 10),
                      (offer.player?.overallRating?.toStringAsFixed(0) ?? '-')
                          .text
                          .lg
                          .semiBold
                          .color(offer
                              .player?.performanceTestVerification?.scoreColor)
                          .make(),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                  UiSpacer.horizontalSpace(),
                  VStack(
                    [
                      (offer.player?.name ?? '-')
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
                      ('${offer.player?.height?.value ?? '-'} ${offer.player?.height?.unit} / ${offer.player?.weight?.value ?? '-'} ${offer.player?.weight?.unit}')
                          .text
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
                          .onInkTap(
                              () => controller.cancelOfferingPlayer(offer))
                      : (offer.status?.name ?? '-')
                          .text
                          .semiBold
                          .color(offer.statusColor)
                          .make()
                ])
                    .p8()
                    .onInkTap(() => controller.openDetailPlayer(offer.player));
              }),
        ).p12(),
      ),
    );
  }
}
