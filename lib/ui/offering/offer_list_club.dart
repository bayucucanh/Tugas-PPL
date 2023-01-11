import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/offering/controller/offer_list_club.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferListClub extends GetView<OfferListClubController> {
  static const routeName = '/clubs/offers';
  const OfferListClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OfferListClubController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tawaran Klub'.text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.offerings.value.data?.length ?? 0,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              final offer = controller.offerings.value.data?[index];
              return VStack([
                (offer?.club?.name as String? ?? '-')
                    .text
                    .semiBold
                    .maxLines(2)
                    .ellipsis
                    .makeCentered()
                    .expand(),
                UiSpacer.verticalSpace(space: 5),
                CachedNetworkImage(
                  imageUrl: offer?.club?.photo == null
                      ? offer!.club!.gravatar()
                      : offer!.club!.photo!,
                  fit: BoxFit.cover,
                ).wh(100, 100).cornerRadius(50).centered(),
                UiSpacer.verticalSpace(space: 5),
                (offer.status?.name as String? ?? '-')
                    .text
                    .color(offer.statusColor)
                    .makeCentered(),
              ])
                  .p12()
                  .card
                  .make()
                  .onInkTap(() => controller.openOffering(offer));
            },
          ).p12(),
        ),
      ),
    );
  }
}
