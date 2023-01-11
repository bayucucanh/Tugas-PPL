import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/offering/controller/offer_list_team_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferTeamCoachList extends GetView<OfferListTeamCoachController> {
  static const routeName = '/teams/offers/coach';
  const OfferTeamCoachList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OfferListTeamCoachController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tawaran Gabung Tim'.text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.offerings.value.data!.isEmpty
              ? 'Belum tersedia penawaran untuk bergabung dengan tim.'
                  .text
                  .center
                  .makeCentered()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.offerings.value.data?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 220,
                  ),
                  itemBuilder: (context, index) {
                    final offer = controller.offerings.value.data?[index];
                    return VStack([
                      (offer?.team?.name ?? '-')
                          .text
                          .semiBold
                          .maxLines(2)
                          .ellipsis
                          .makeCentered()
                          .expand(),
                      UiSpacer.verticalSpace(space: 5),
                      Avatar(
                        name: offer?.team?.name ?? '-',
                        useCache: true,
                      ).wh(100, 100).centered(),
                      UiSpacer.verticalSpace(space: 5),
                      (offer?.status == 0 ? 'Pending' : '-')
                          .text
                          .makeCentered(),
                    ])
                        .p12()
                        .card
                        .make()
                        .onInkTap(() => controller.openDetailOffer(offer));
                  },
                ).p12(),
        ),
      ),
    );
  }
}
