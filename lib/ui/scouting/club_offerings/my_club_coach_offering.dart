import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/my_club_coach_offering.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class MyClubCoachOffering extends GetView<MyClubCoachOfferingController> {
  const MyClubCoachOffering({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyClubCoachOfferingController());
    return Obx(
      () => SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: controller.offerings!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Belum pernah melakukan offering pelatih.',
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
