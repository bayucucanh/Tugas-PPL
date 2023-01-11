import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/profile/controller/detail_profile.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerProfile extends GetView<DetailProfileController> {
  static const routeName = '/profile/player';
  const PlayerProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DetailProfileController());
    return DefaultScaffold(
      title: 'Detail Profil'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: const [
        // IconButton(onPressed: null, icon: Icon(Icons.share_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: controller.initialize,
        child: Obx(
          () => VStack([
            VStack([
              HStack([
                'Last Update: ${controller.myPerformance?.formatCreatedAt ?? '-'}'
                    .text
                    .color(primaryColor)
                    .light
                    .sm
                    .make(),
              ]),
              UiSpacer.verticalSpace(),
              Screenshot(
                controller: controller.screenshotController,
                child: ZStack([
                  Image.asset(
                    'assets/images/player_card.png',
                  ).centered(),
                  (controller.player?.name ?? '-')
                      .text
                      .ellipsis
                      .center
                      .xl
                      .maxLines(2)
                      .semiBold
                      .white
                      .make()
                      .positioned(
                        top: 50,
                        left: 70,
                        right: 70,
                      ),
                  HStack(
                    [
                      VStack([
                        (controller.player?.overallRating?.toStringAsFixed(0) ??
                                '-')
                            .text
                            .white
                            .xl3
                            .semiBold
                            .make(),
                        '_______________'.text.white.xs.make(),
                        (controller.player?.nationality?.code ?? '-')
                            .text
                            .white
                            .xl3
                            .semiBold
                            .make(),
                        '_______________'.text.white.xs.make(),
                        (controller.player?.ageCard ?? '-')
                            .text
                            .xl3
                            .semiBold
                            .white
                            .make(),
                      ]),
                      UiSpacer.horizontalSpace(space: 10),
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                            controller.player?.photo == null
                                ? controller.player!.gravatar()
                                : controller.player!.photo!),
                      ).wh(120, 120),
                    ],
                  ).centered().positioned(
                        top: 100,
                        left: 50,
                        right: 50,
                      ),
                  if (controller.player?.position?.name != null)
                    (controller.player?.position?.name ?? '')
                        .text
                        .center
                        .white
                        .xl
                        .make()
                        .positioned(top: 240, left: 50, right: 50),
                  (controller.player?.clubPlayer?.club?.name?.toUpperCase() ??
                          'Belum ada klub')
                      .text
                      .center
                      .white
                      .lg
                      .make()
                      .positioned(top: 268, left: 50, right: 50),
                  HStack([
                    VStack([
                      HStack([
                        'TEK'.text.white.xl.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.player?.performanceTestVerification
                                    ?.totalTechnique ??
                                '0')
                            .text
                            .center
                            .white
                            .xl
                            .make(),
                      ]),
                      UiSpacer.verticalSpace(space: 10),
                      HStack([
                        'ATT'.text.white.xl.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.player?.performanceTestVerification
                                    ?.totalAttack ??
                                '0')
                            .text
                            .center
                            .white
                            .xl
                            .make(),
                      ]),
                      UiSpacer.verticalSpace(space: 10),
                      HStack([
                        'DEF'.text.white.xl.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.player?.performanceTestVerification
                                    ?.totalDefend ??
                                '0')
                            .text
                            .center
                            .white
                            .xl
                            .make(),
                      ])
                    ]),
                    UiSpacer.verticalDivider(width: 40, color: Colors.white),
                    VStack([
                      HStack([
                        'FIS'.text.white.xl.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.player?.performanceTestVerification
                                    ?.totalPhsyique ??
                                '0')
                            .text
                            .center
                            .white
                            .xl
                            .make(),
                      ]),
                      UiSpacer.verticalSpace(space: 10),
                      HStack([
                        'MEN'.text.white.xl.make(),
                        UiSpacer.horizontalSpace(space: 5),
                        (controller.player?.performanceTestVerification
                                    ?.scatScore ??
                                0)
                            .text
                            .center
                            .white
                            .xl
                            .make(),
                      ])
                    ])
                  ]).centered().positioned(bottom: 60, left: 80, right: 70),
                ]),
              ),
              UiSpacer.verticalSpace(),
              HStack(
                [
                  'Detail'
                      .text
                      .color(primaryColor)
                      .makeCentered()
                      .box
                      .p12
                      .roundedSM
                      .transparent
                      .border(color: primaryColor)
                      .make()
                      .onInkTap(controller.openDetailStatistics),
                  'Bagikan'
                      .text
                      .color(primaryColor)
                      .makeCentered()
                      .box
                      .p12
                      .roundedSM
                      .transparent
                      .border(color: primaryColor)
                      .make()
                      .onTap(() => controller.shareImage(context)),
                  if (!controller.userData.value.isClub)
                    'Update'
                        .text
                        .white
                        .makeCentered()
                        .box
                        .p12
                        .roundedSM
                        .color(primaryColor)
                        .make()
                        .onTap(controller.openUpdateParameter),
                ],
                alignment: MainAxisAlignment.spaceBetween,
                axisSize: MainAxisSize.max,
              )
            ]).p12().card.make(),
            UiSpacer.verticalSpace(),
            if (controller.userData.value.isPlayer)
              VStack([
                'Informasi Karir'.text.xl.semiBold.make(),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.military_tech_rounded),
                      title: 'Pengalaman'.text.make(),
                      onTap: controller.openExperiences,
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.graduationCap),
                      title: 'Riwayat Pendidikan'.text.make(),
                      onTap: controller.openEducation,
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.award),
                      title: 'Penghargaan'.text.make(),
                      onTap: controller.openAchievements,
                    ),
                    ListTile(
                      leading: const Icon(FontAwesomeIcons.trophy),
                      title: 'Kejuaraan'.text.make(),
                      onTap: controller.openChampionship,
                    ),
                    ListTile(
                      leading: const Icon(Icons.stars_rounded),
                      title: 'Cari Klub'.text.make(),
                      onTap: controller.openSearchClub,
                    ),
                    ListTile(
                      leading: const Icon(Icons.book_rounded),
                      title: 'Lowongan Tersimpan'.text.make(),
                      onTap: controller.openVacancies,
                    ),
                    ListTile(
                      leading: const Icon(Icons.loyalty_rounded),
                      title: 'Tawaran'.text.make(),
                      onTap: controller.openTeamOffers,
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_rounded),
                      title: 'Konsultasi'.text.make(),
                      onTap: controller.openConsulting,
                    ),
                  ],
                ),
              ]),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
