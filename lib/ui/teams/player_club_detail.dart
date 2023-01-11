import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/player.card.dart';
import 'package:mobile_pssi/ui/scouting/parts/detail_chart.dart';
import 'package:mobile_pssi/ui/scouting/parts/field_position.dart';
import 'package:mobile_pssi/ui/teams/controller/player_club_detail.controller.dart';
import 'package:mobile_pssi/ui/teams/parts/chart_category.dart';
import 'package:mobile_pssi/ui/teams/parts/mental_tab.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerClubDetail extends GetView<PlayerClubDetailController> {
  static const routeName = '/club/player/detail';
  const PlayerClubDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerClubDetailController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: (controller.player?.name ?? '-').text.make(),
        body: VStack([
          PlayerCard(player: controller.player!),
          UiSpacer.verticalSpace(space: 10),
          HStack([
            VStack([
              HStack([
                'Performa : '.text.semiBold.make(),
                (controller.player?.performanceTestVerification?.recommended
                            ?.name ??
                        'Belum ada rekomendasi')
                    .text
                    .make(),
              ]),
              UiSpacer.verticalSpace(space: 5),
              HStack([
                'Last Update : '.text.italic.sm.make(),
                (controller.player?.performanceTestVerification
                            ?.formatUpdated ??
                        '-')
                    .text
                    .sm
                    .italic
                    .make(),
              ]),
            ]).expand(),
            VStack(
              [
                'Overall Rating'.text.semiBold.make(),
                (controller.player?.performanceTestVerification?.avgResults
                            ?.toStringAsFixed(1) ??
                        '-')
                    .text
                    .xl4
                    .color(controller
                        .player?.performanceTestVerification?.scoreColor)
                    .make()
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
          ]),
          FieldPosition(
            player: controller.player,
          ),
          DefaultTabController(
            length: 5,
            child: VStack([
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: 'Teknik',
                  ),
                  Tab(
                    text: 'Fisik',
                  ),
                  Tab(
                    text: 'Taktik: Attacking',
                  ),
                  Tab(
                    text: 'Taktik: Defending',
                  ),
                  Tab(
                    text: 'Mental',
                  ),
                ],
              ),
              TabBarView(children: [
                const ChartCategory(categoryId: 1),
                const ChartCategory(categoryId: 2),
                const ChartCategory(categoryId: 3),
                const ChartCategory(categoryId: 4),
                MentalTab(
                    performanceTestVerification:
                        controller.player?.performanceTestVerification),
              ]).h(250),
            ]),
          ),
          HStack(
            [
              DetailChart(
                title: 'Detil Teknik',
                performanceTests: controller.player?.performanceTestVerification
                    ?.getPerformanceVerificationByCategoryId(1),
              ).expand(),
              DetailChart(
                title: 'Detil Fisik',
                performanceTests: controller.player?.performanceTestVerification
                    ?.getPerformanceVerificationByCategoryId(2),
              ).expand(),
            ],
            alignment: MainAxisAlignment.spaceBetween,
            crossAlignment: CrossAxisAlignment.center,
            axisSize: MainAxisSize.max,
          ),
          HStack(
            [
              DetailChart(
                title: 'Detil Taktik : Attacking',
                performanceTests: controller.player?.performanceTestVerification
                    ?.getPerformanceVerificationByCategoryId(3),
              ).expand(),
              DetailChart(
                title: 'Detil Taktik : Defending',
                performanceTests: controller.player?.performanceTestVerification
                    ?.getPerformanceVerificationByCategoryId(4),
              ).expand(),
            ],
            alignment: MainAxisAlignment.spaceBetween,
            crossAlignment: CrossAxisAlignment.center,
            axisSize: MainAxisSize.max,
          ),
          UiSpacer.verticalSpace(),
          'Tugas Pernah Dikerjakan'.text.semiBold.make(),
          UiSpacer.verticalSpace(),
          controller.tasks.value.data!.isEmpty
              ? 'Belum pernah melakukan tugas'.text.makeCentered()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final task = controller.tasks.value.data?[index];
                    return ZStack([
                      VStack([
                        task?.learningTask?.thumbnailVideo == null
                            ? const Icon(Icons.image_not_supported_rounded)
                                .wh(115, 115)
                            : CachedNetworkImage(
                                imageUrl: task!.learningTask!.thumbnailVideo!),
                        UiSpacer.verticalSpace(space: 10),
                        (task?.learningTask?.learning?.name ?? '-')
                            .text
                            .ellipsis
                            .make()
                            .expand(),
                      ]),
                      (task?.employee?.name ?? '-')
                          .text
                          .xs
                          .white
                          .make()
                          .box
                          .p8
                          .gray500
                          .bottomRounded(value: 10)
                          .make()
                          .positioned(right: 0, top: 0),
                    ])
                        .px(14)
                        .w(180)
                        .onTap(() => controller.openVideo(task?.learningTask));
                  },
                  shrinkWrap: true,
                  itemCount: controller.tasks.value.data?.length ?? 0,
                ).h(140),
          UiSpacer.verticalSpace(space: 40),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
