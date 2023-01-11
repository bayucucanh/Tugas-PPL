import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/club/controller/coach_club_detail.controller.dart';
import 'package:mobile_pssi/ui/club/parts/empty.club.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachClubDetail extends GetView<CoachClubDetailController> {
  const CoachClubDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachClubDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Klub Saya'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.userData.value.employee?.clubCoach == null
              ? const EmptyClub().centered()
              : VStack([
                  HStack([
                    CachedNetworkImage(
                      imageUrl: controller.club?.photo == null
                          ? controller.club!.gravatar()
                          : controller.club!.photo!,
                      fit: BoxFit.cover,
                    ).h(100).w(100).cornerRadius(50),
                    UiSpacer.horizontalSpace(space: 10),
                    VStack([
                      (controller.club?.name ?? '-').text.semiBold.xl2.make(),
                      UiSpacer.verticalSpace(space: 10),
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
                          UiSpacer.horizontalSpace(space: 10),
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
                        '${controller.club?.rating ?? '0.0'}'
                            .text
                            .sm
                            .size(26)
                            .make()
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ),
                  ]),
                  UiSpacer.verticalSpace(),
                  'Tim Pelatih'.text.semiBold.xl.make(),
                  UiSpacer.verticalSpace(),
                  SmartRefresher(
                          controller: controller.teamRefresh,
                          enablePullUp: true,
                          enablePullDown: false,
                          onLoading: controller.loadMoreTeam,
                          scrollDirection: Axis.horizontal,
                          child: controller.teams!.isEmpty
                              ? 'Anda belum diundang ke dalam sebuah tim di klub.'
                                  .text
                                  .makeCentered()
                              : ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final coachTeam = controller.teams?[index];
                                    return HStack(
                                      [
                                        VStack(
                                          [
                                            Avatar(
                                              name:
                                                  coachTeam?.team?.name ?? '-',
                                              useCache: true,
                                            ),
                                            UiSpacer.verticalSpace(space: 5),
                                            (coachTeam?.team?.name ?? '-')
                                                .text
                                                .center
                                                .semiBold
                                                .ellipsis
                                                .maxLines(2)
                                                .make()
                                                .w(100),
                                          ],
                                          crossAlignment:
                                              CrossAxisAlignment.center,
                                          alignment: MainAxisAlignment.center,
                                        ),
                                        UiSpacer.horizontalSpace(space: 10),
                                        VStack(
                                          [
                                            'Rating'.text.semiBold.xl.make(),
                                            UiSpacer.verticalSpace(),
                                            '${coachTeam?.team?.teamRate ?? '0'}'
                                                .text
                                                .xl3
                                                .make()
                                          ],
                                          crossAlignment:
                                              CrossAxisAlignment.center,
                                        ).centered()
                                      ],
                                      alignment: MainAxisAlignment.start,
                                      crossAlignment: CrossAxisAlignment.start,
                                    ).p12().card.make();
                                  },
                                  itemCount: controller.teams?.length ?? 0,
                                ).h(170))
                      .h(170)
                ]).p12(),
        ),
      ),
    );
  }
}
