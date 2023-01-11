import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/statistics/controller/detail_statistic.controller.dart';
import 'package:mobile_pssi/ui/statistics/parts/tab_mental.dart';
import 'package:mobile_pssi/ui/statistics/parts/tab_physique.dart';
import 'package:mobile_pssi/ui/statistics/parts/tab_tactic.dart';
import 'package:mobile_pssi/ui/statistics/parts/tab_technique.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailStatistic extends GetView<DetailStatisticController> {
  static const routeName = '/statistics/detail';
  const DetailStatistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DetailStatisticController());
    return DefaultTabController(
      length: 4,
      child: DefaultScaffold(
        title: 'Detail Statistik'.text.make(),
        backgroundColor: Get.theme.backgroundColor,
        actions: [
          IconButton(
            onPressed: controller.downloadCV,
            icon: const Icon(Icons.preview_rounded),
            tooltip: 'Preview Download CV',
          )
        ],
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          enablePullDown: true,
          child: Obx(
            () => VStack([
              VStack([
                'Overall Rating'.text.semiBold.xl.make(),
                HStack([
                  (controller.myPerformance?.avgResults?.toStringAsFixed(0) ??
                          '-')
                      .text
                      .xl5
                      .color(freeColor)
                      .semiBold
                      .make(),
                  'Performa: ${controller.myPerformance?.recommended == null ? 'Belum ada rekomendasi' : controller.myPerformance?.recommended?.name ?? '-'}'
                      .text
                      .semiBold
                      .make(),
                ]).centered()
              ]).p12().card.make(),
              UiSpacer.verticalSpace(),
              HStack([
                'Diagram'.text.lg.semiBold.make().expand(),
                'Last Update : ${controller.myPerformance?.formatUpdated ?? '-'}'
                    .text
                    .sm
                    .color(primaryColor)
                    .make(),
              ]),
              UiSpacer.verticalSpace(),
              const TabBar(tabs: [
                Tab(
                  text: 'Fisik',
                ),
                Tab(
                  text: 'Teknik',
                ),
                Tab(
                  text: 'Taktik',
                ),
                Tab(
                  text: 'Mental',
                ),
              ]),
              const TabBarView(children: [
                TabPhysique(),
                TabTechnique(),
                TabTactic(),
                TabMental(),
              ]).expand(),
              if (!controller.userData.value.isClub)
                'Update'
                    .text
                    .white
                    .makeCentered()
                    .continuousRectangle(
                        height: 40, backgroundColor: primaryColor)
                    .onTap(controller.updateRequest)
            ]).p12().safeArea(),
          ),
        ),
      ),
    );
  }
}
