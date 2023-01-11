import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/club/controller/club_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubDetail extends GetView<ClubDetailController> {
  static const routeName = '/club/detail';
  const ClubDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: (controller.userData.value.isPlayer
              ? (controller.club?.name ?? '-')
              : 'Klub Saya')
          .text
          .make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: controller.refreshData,
        child: Obx(
          () => VStack([
            HStack([
              CachedNetworkImage(
                imageUrl: controller.club?.photo == null
                    ? controller.club!.gravatar()
                    : controller.club!.photo!,
                fit: BoxFit.cover,
              ).h(100).cornerRadius(100),
              UiSpacer.horizontalSpace(space: 10),
              VStack([
                (controller.club?.name ?? '-').text.semiBold.ellipsis.xl.make(),
                UiSpacer.verticalSpace(space: 10),
                if (controller.userData.value.isClub)
                  HStack(
                    [
                      VStack(
                        [
                          SvgPicture.asset(
                            'assets/images/soccer-player-svgrepo-com.svg',
                            color: Colors.white,
                          )
                              .wh(30, 30)
                              .box
                              .color(primaryColor)
                              .roundedFull
                              .make(),
                          UiSpacer.verticalSpace(space: 5),
                          'List Pelatih'.text.sm.make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ).onTap(controller.openCoachList),
                      VStack(
                        [
                          SvgPicture.asset(
                            'assets/images/athletic-soccer-player-svgrepo-com.svg',
                            color: Colors.white,
                          )
                              .wh(30, 30)
                              .box
                              .color(primaryColor)
                              .roundedFull
                              .make(),
                          UiSpacer.verticalSpace(space: 5),
                          'List Pemain'.text.sm.make(),
                        ],
                        alignment: MainAxisAlignment.start,
                        crossAlignment: CrossAxisAlignment.center,
                        axisSize: MainAxisSize.min,
                      ).onTap(controller.openPlayerList),
                    ],
                    alignment: MainAxisAlignment.spaceAround,
                    axisSize: MainAxisSize.max,
                  ),
              ]).expand(),
              VStack(
                [
                  'Rating'.text.semiBold.xl2.make(),
                  '${controller.club?.rating ?? '0.0'}'.text.sm.size(26).make()
                ],
                crossAlignment: CrossAxisAlignment.center,
              ),
            ]),
            UiSpacer.verticalSpace(),
            'Tim Klub'.text.semiBold.xl.make(),
            UiSpacer.verticalSpace(),
            SmartRefresher(
                    controller: controller.teamRefresh,
                    enablePullUp: true,
                    enablePullDown: false,
                    onLoading: controller.loadMoreTeam,
                    scrollDirection: Axis.horizontal,
                    child: controller.teams!.isEmpty
                        ? EmptyWithButton(
                            emptyMessage: 'Belum memiliki tim',
                            textButton: 'Buat Tim',
                            showButton: controller.userData.value.isPlayer
                                ? false
                                : true,
                            onTap: controller.openTeam,
                          )
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final team = controller.teams?[index];
                              return HStack(
                                [
                                  VStack(
                                    [
                                      Avatar(
                                        name: team?.name ?? '-',
                                        useCache: true,
                                      ),
                                      UiSpacer.verticalSpace(space: 5),
                                      (team?.name ?? '-')
                                          .text
                                          .center
                                          .semiBold
                                          .ellipsis
                                          .maxLines(2)
                                          .make()
                                          .w(100),
                                    ],
                                    crossAlignment: CrossAxisAlignment.center,
                                    alignment: MainAxisAlignment.center,
                                  ),
                                  UiSpacer.horizontalSpace(space: 10),
                                  VStack(
                                    [
                                      'Rating'.text.semiBold.xl.make(),
                                      UiSpacer.verticalSpace(),
                                      '${team?.teamRate ?? '0'}'.text.xl3.make()
                                    ],
                                    crossAlignment: CrossAxisAlignment.center,
                                  ).centered()
                                ],
                                alignment: MainAxisAlignment.start,
                                crossAlignment: CrossAxisAlignment.start,
                              ).p12().card.make();
                            },
                            itemCount: controller.teams?.length ?? 0,
                          ).h(170))
                .h(180),
            UiSpacer.verticalSpace(),
            if (controller.userData.value.isPlayer)
              VStack([
                'Promosi Tersedia'.text.semiBold.xl.make(),
                UiSpacer.verticalSpace(),
                controller.promotions!.isEmpty
                    ? const EmptyWithButton(
                        emptyMessage: 'Tidak ada promosi tersedia.',
                        showButton: false,
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final promo = controller.promotions?[index];
                          return ListTile(
                            title: (promo?.promoLabel ?? '-').text.make(),
                            subtitle: 'Lihat Detil'.text.make(),
                            onTap: () => controller.openPromotion(promo),
                            trailing: (promo?.elapsedTimeSinceCreated ?? '-')
                                .text
                                .sm
                                .make(),
                          );
                        },
                        itemCount: controller.promotions?.length ?? 0,
                      ),
              ]),
          ]).p12(),
        ),
      ),
    );
  }
}
