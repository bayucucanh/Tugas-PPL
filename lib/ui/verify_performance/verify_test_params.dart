import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/video_player.spacebar.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/tab_attack.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/tab_defend.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/tab_mental.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/tab_physic.dart';
import 'package:mobile_pssi/ui/verify_performance/parts/tab_technique.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyTestParams extends GetView<VerifyTestParamsController> {
  static const routeName = '/test-parameter/detail';
  const VerifyTestParams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyTestParamsController());
    return Obx(
      () => DefaultTabController(
        length: 5,
        child: DefaultScaffold(
          backgroundColor: Get.theme.backgroundColor,
          showAppBar: false,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: 'Detil Test Parameters'.text.white.sm.make(),
                leading: const BackButton(
                  color: Colors.white,
                ),
                backgroundColor: Colors.black,
              ),
              SliverAppBar(
                collapsedHeight: 190,
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: VideoPlayerSpaceBar(
                    loadVideo: controller.isLoadingVideo.value,
                    playerController: controller.podPlayerController,
                  ),
                ),
              ),
            ],
            body: Form(
              key: controller.verifyForm,
              child: VStack([
                HStack(
                  [
                    'Rekomendasi'.text.semiBold.xl.make(),
                    Visibility(
                        visible: controller.recommendationEdit.value,
                        replacement: controller.selectRecommendation.value.id ==
                                null
                            ? controller.verifyDetail.value.recommended == null
                                ? 'Belum ada rekomendasi'.text.make()
                                : (controller.verifyDetail.value.recommended
                                            ?.name ??
                                        '-')
                                    .text
                                    .make()
                            : (controller.selectRecommendation.value.name ??
                                    '-')
                                .text
                                .make(),
                        child: HStack([
                          DropdownButtonFormField(
                            isExpanded: true,
                            menuMaxHeight: 250,
                            items: controller.recommendations.value.data
                                ?.map(
                                  (e) => DropdownMenuItem(
                                      value: e,
                                      child: (e.name ?? '-').text.make()),
                                )
                                .toList(),
                            onChanged: controller.changeRecommendation,
                          ).w(140),
                          IconButton(
                            icon: const Icon(Icons.close, color: primaryColor),
                            onPressed: controller.editRecommendation,
                          ),
                        ])).onTap(controller.editRecommendation),
                  ],
                  alignment: MainAxisAlignment.spaceBetween,
                  axisSize: MainAxisSize.max,
                ),
                UiSpacer.verticalSpace(space: 10),
                HStack(
                  [
                    'Status'.text.semiBold.xl.make(),
                    (controller.verifyDetail.value.status?.name ?? '-')
                        .text
                        .end
                        .white
                        .make()
                        .box
                        .p8
                        .roundedSM
                        .color(controller.verifyDetail.value.status!
                            .getStatusColor()!)
                        .make()
                  ],
                  alignment: MainAxisAlignment.spaceBetween,
                  axisSize: MainAxisSize.max,
                ),
                UiSpacer.verticalSpace(),
                const TabBar(
                  tabs: [
                    Tab(
                      text: 'Teknik',
                    ),
                    Tab(
                      text: 'Fisik',
                    ),
                    Tab(
                      text: 'Taktik : Attacking',
                    ),
                    Tab(
                      text: 'Taktik : Defending',
                    ),
                    Tab(
                      text: 'Mental',
                    ),
                  ],
                  isScrollable: true,
                ),
                const TabBarView(
                  children: [
                    TabTechnique(),
                    TabPhsyic(),
                    TabAttack(),
                    TabDefend(),
                    TabMental(),
                  ],
                ).expand(),
              ]).p12(),
            ).pOnly(bottom: controller.viewInset),
          ),
          floatingActionButton: controller.verifyDetail.value.status?.id == 0
              ? FloatingActionButton.extended(
                  onPressed: controller.openFormSheet,
                  label: 'Verifikasi'.text.make())
              : null,
        ),
      ),
    );
  }
}
