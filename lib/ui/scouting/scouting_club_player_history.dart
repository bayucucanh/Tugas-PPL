import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/club_player_scouting_history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ScoutingClubPlayerHistory
    extends GetView<ClubPlayerScoutingHistoryController> {
  static const routeName = '/scouting/club/player/history';
  const ScoutingClubPlayerHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubPlayerScoutingHistoryController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Riwayat Penawaran Klub Pemain'.text.sm.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          enablePullDown: true,
          enablePullUp: true,
          child: controller.offerings!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage:
                      'Belum pernah mengirimkan penawaran pada pemain klub.',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  itemCount: controller.offerings?.length ?? 0,
                  itemBuilder: (context, index) {
                    final offer = controller.offerings?[index];
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
                          (offer.player?.overallRating?.toStringAsFixed(0) ??
                                  '-')
                              .text
                              .lg
                              .semiBold
                              .color(offer.player?.performanceTestVerification
                                  ?.scoreColor)
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
                    ]).p8().onInkTap(
                        () => controller.openDetailPlayer(offer.player));
                  }),
        ).p12(),
      ),
    );
  }
}
