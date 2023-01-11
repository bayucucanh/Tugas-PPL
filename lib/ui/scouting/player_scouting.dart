import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/scouting/controller/player_scouting.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerScouting extends GetView<PlayerScoutingController> {
  static const routeName = '/scouting/player';
  const PlayerScouting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerScoutingController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Player Scouting'.text.make(),
      actions: [
        IconButton(
          onPressed: controller.getHistory,
          icon: const Icon(Icons.work_history_rounded),
          tooltip: 'Riwayat Penawaran Pemain',
        ),
        IconButton(
          onPressed: controller.getClubPlayerHistory,
          icon: const Icon(Icons.transfer_within_a_station_rounded),
          tooltip: 'Riwayat Penawaran Klub Pemain',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Obx(
          () => VStack([
            TextFormComponent(
              controller: controller.search,
              textInputAction: TextInputAction.search,
              validator: (val) {
                return null;
              },
              label: 'Cari ID pemain atau nama pemain',
              suffixIcon: IconButton(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.search),
              ),
            ),
            UiSpacer.verticalSpace(space: 5),
            HStack([
              ListView(scrollDirection: Axis.horizontal, children: [
                (controller.positionFilter.value.name ?? 'Posisi')
                    .text
                    .semiBold
                    .white
                    .make()
                    .box
                    .p8
                    .roundedSM
                    .color(primaryColor)
                    .make()
                    .onTap(controller.openFilterPositionDialog),
                UiSpacer.horizontalSpace(space: 10),
                (controller.domicileFilter.value.name ?? 'Domisili')
                    .text
                    .semiBold
                    .white
                    .make()
                    .box
                    .p8
                    .roundedSM
                    .color(primaryColor)
                    .make()
                    .onTap(controller.openFilterDomicileDialog),
                UiSpacer.horizontalSpace(space: 10),
                (controller.heightFilter.text.isNotEmptyAndNotNull
                        ? '${controller.heightFilter.text} cm'
                        : 'Tinggi Badan')
                    .text
                    .semiBold
                    .white
                    .make()
                    .box
                    .p8
                    .roundedSM
                    .color(primaryColor)
                    .make()
                    .onTap(controller.openFilterHeightDialog),
                UiSpacer.horizontalSpace(space: 10),
                (controller.weightFilter.text.isNotEmptyAndNotNull
                        ? '${controller.weightFilter.text} Kg'
                        : 'Berat Badan')
                    .text
                    .semiBold
                    .white
                    .make()
                    .box
                    .p8
                    .roundedSM
                    .color(primaryColor)
                    .make()
                    .onTap(controller.openFilterWeightDialog),
              ]).h(35).expand(),
              UiSpacer.horizontalSpace(),
              'Reset'
                  .text
                  .semiBold
                  .color(primaryColor)
                  .make()
                  .onTap(controller.resetFilter),
            ]),
          ]).p12(),
        ),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        primary: true,
        child: Obx(
          () => controller.players.value.data!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada data pemain',
                  showButton: false,
                  showImage: true,
                ).centered()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemExtent: 110,
                  itemCount: controller.players.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final player = controller.players.value.data?[index];
                    return HStack(
                      [
                        CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                              player?.photo == null
                                  ? player!.gravatar()
                                  : player!.photo!),
                        ).wh(70, 70),
                        UiSpacer.horizontalSpace(space: 10),
                        VStack([
                          (player.name ?? '-')
                              .text
                              .semiBold
                              .maxLines(2)
                              .ellipsis
                              .make(),
                          (player.position?.name ?? 'Belum ada posisi')
                              .text
                              .make(),
                          '${player.height?.value ?? '-'} ${player.height?.unit} / ${player.weight?.value ?? '-'} ${player.weight?.unit}'
                              .text
                              .sm
                              .make(),
                          player.clubPlayer != null
                              ? HStack([
                                  (player.clubPlayer?.club?.name ?? '-')
                                      .text
                                      .sm
                                      .make(),
                                  if (player.clubPlayer?.playerTeam != null)
                                    HStack([
                                      UiSpacer.horizontalSpace(space: 5),
                                      (player.clubPlayer?.playerTeam?.team
                                                  ?.ageGroup?.name ??
                                              '-')
                                          .text
                                          .sm
                                          .make()
                                    ]),
                                ])
                              : 'Tanpa Klub'.text.sm.make()
                        ]).expand(),
                        UiSpacer.horizontalSpace(space: 10),
                        VStack(
                          [
                            'Rating'.text.semiBold.make(),
                            (player.overallRating?.toStringAsFixed(1) ?? '-')
                                .text
                                .color(player
                                    .performanceTestVerification?.scoreColor)
                                .xl3
                                .make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        )
                      ],
                    ).p8().onInkTap(
                          () => controller.getDetail(player),
                        );
                  },
                ),
        ).p12(),
      ),
    );
  }
}
