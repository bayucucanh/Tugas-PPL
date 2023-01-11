import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/club_coach_scouting_history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ScoutingClubCoachHistory
    extends GetView<ClubCoachScoutingHistoryController> {
  static const routeName = '/scouting/club/coach/history';
  const ScoutingClubCoachHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubCoachScoutingHistoryController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Riwayat Penawaran Klub Pelatih'.text.sm.make(),
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
                      'Belum pernah mengirimkan penawaran pada pelatih klub.',
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
                            imageUrl: offer?.employee?.photo == null
                                ? offer!.employee!.gravatar()
                                : offer!.employee!.photo!,
                            fit: BoxFit.cover,
                          ).wh(75, 75).cornerRadius(80),
                          UiSpacer.verticalSpace(space: 10),
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
                              .onInkTap(
                                  () => controller.cancelOfferingCoach(offer))
                          : (offer.status?.name ?? '-')
                              .text
                              .semiBold
                              .color(offer.statusColor)
                              .make()
                    ]).p8().onInkTap(
                        () => controller.openDetailCoach(offer.employee));
                  }),
        ).p12(),
      ),
    );
  }
}
