import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/my_club_player_offering.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class MyClubPlayerOffering extends GetView<MyClubPlayerOfferingController> {
  const MyClubPlayerOffering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyClubPlayerOfferingController());
    return Obx(
      () => SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: controller.offerings!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Belum pernah melakukan offering pemain.',
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
                          imageUrl: offer?.player?.photo == null
                              ? offer!.player!.gravatar()
                              : offer!.player!.photo!,
                          fit: BoxFit.cover,
                        ).wh(75, 75).cornerRadius(80),
                        UiSpacer.verticalSpace(space: 10),
                        'Rating'.text.semiBold.make(),
                        (offer.player?.overallRating?.toStringAsFixed(0) ?? '-')
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
                        ('${offer.player?.height?.value} ${offer.player?.height?.unit} / ${offer.player?.weight?.value} ${offer.player?.weight?.unit}')
                            .text
                            .make(),
                      ],
                      alignment: MainAxisAlignment.start,
                      crossAlignment: CrossAxisAlignment.start,
                    ).expand(),
                    (offer.status?.name ?? '-')
                        .text
                        .color(offer.statusColor)
                        .make(),
                  ]).p8().onInkTap(() => controller.openConfirmation(offer));
                }),
      ),
    );
  }
}
