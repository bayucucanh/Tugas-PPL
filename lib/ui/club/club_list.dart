import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/club/controller/club_list.controller.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubList extends GetView<ClubListController> {
  static const routeName = '/clubs';
  const ClubList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubListController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Cari Klub'.text.make(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: TextFormComponent(
          label: 'Cari Klub',
          suffixIcon: IconButton(
              onPressed: controller.refreshData,
              icon: const Icon(Icons.saved_search_rounded)),
          controller: controller.search,
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            Get.focusScope?.unfocus();
            controller.refreshData();
          },
          validator: (String? val) {
            return null;
          },
        ).px12(),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          onLoading: controller.loadMore,
          onRefresh: controller.refreshData,
          enablePullDown: true,
          enablePullUp: true,
          child: controller.promotions!.isEmpty
              ? 'Tidak ada promosi klub tersedia'.text.makeCentered()
              : GridView.builder(
                  itemCount: controller.promotions?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 260,
                  ),
                  itemBuilder: (context, index) {
                    final promo = controller.promotions?[index];
                    return VStack([
                      (promo?.club?.name ?? '-')
                          .text
                          .semiBold
                          .maxLines(2)
                          .ellipsis
                          .makeCentered()
                          .expand(),
                      UiSpacer.verticalSpace(space: 5),
                      Hero(
                        tag: '${promo?.id}_${promo?.club?.name}',
                        child: CachedNetworkImage(
                          imageUrl: promo?.club?.photo == null
                              ? promo!.club!.gravatar()
                              : promo!.club!.photo!,
                          fit: BoxFit.cover,
                        ).wh(100, 100).cornerRadius(50).centered(),
                      ),
                      UiSpacer.verticalSpace(space: 5),
                      (promo.promoLabel).text.makeCentered(),
                      UiSpacer.verticalSpace(space: 5),
                      HStack([
                        const Icon(
                          Icons.timelapse_rounded,
                          size: 14,
                        ),
                        UiSpacer.horizontalSpace(space: 5),
                        (promo.elapsedTimeSinceCreated ?? '-')
                            .text
                            .xs
                            .ellipsis
                            .make()
                            .expand(),
                      ]).expand(),
                      UiSpacer.verticalSpace(space: 5),
                      'Lihat Detil'
                          .text
                          .white
                          .makeCentered()
                          .continuousRectangle(
                            height: 30,
                            backgroundColor: primaryColor,
                          )
                          .onTap(() => controller.openPromoDetail(promo)),
                    ])
                        .p12()
                        .card
                        .make()
                        .onTap(() => controller.openPromoDetail(promo));
                  }),
        ).p12(),
      ),
    );
  }
}
