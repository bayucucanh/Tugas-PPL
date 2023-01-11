import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/user.card.dart';
import 'package:mobile_pssi/ui/home/parts/class.card.dart';
import 'package:mobile_pssi/ui/profile/controller/coach_profile.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachProfile extends GetView<CoachProfileController> {
  static const routeName = '/profile/coach';
  const CoachProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachProfileController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: (controller.userData.value.isCoach
                ? 'Detail Profil'
                : controller.coach.employee?.name ?? '-')
            .text
            .make(),
        actions: [
          Visibility(
            visible: controller.userData.value.isClub &&
                controller.canSavePlayer.value,
            child: IconButton(
              onPressed: controller.saveCoach,
              tooltip: 'Simpan Pelatih',
              icon: const Icon(Icons.save_rounded),
            ),
          ),
          if (controller.userData.value.isClub)
            IconButton(
              onPressed: controller.openOffer,
              tooltip: 'Penawaran Pelatih',
              icon: const Icon(Icons.handshake_rounded),
            ),
        ],
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshCoachProfile,
          enablePullDown: true,
          enablePullUp: false,
          child: VStack([
            UserCard(coach: controller.coach),
            UiSpacer.verticalSpace(),
            HStack(
              [
                'Pengalaman'.text.semiBold.white.sm.make().onTap(
                    () => controller.openExperiences(user: controller.coach)),
                'Kelas'
                    .text
                    .semiBold
                    .sm
                    .white
                    .make()
                    .onTap(controller.openCoachClass),
                if (controller.userData.value.isClub)
                  'Tawarkan Bergabung'
                      .text
                      .white
                      .semiBold
                      .make()
                      .onTap(controller.openOffer),
              ],
              axisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceAround,
            ).py16().px12().card.color(primaryColor).make(),
            if (controller.userData.value.isPlayer &&
                controller.coach.classificationUser != null)
              VStack([
                'Konsultasi'.text.semiBold.lg.make(),
                UiSpacer.verticalSpace(space: 10),
                HStack(
                  [
                    VStack(
                      [
                        HStack([
                          const Icon(
                            Icons.hourglass_bottom_rounded,
                            size: 16,
                          ),
                          UiSpacer.horizontalSpace(space: 5),
                          'Jam Kerja'.text.make(),
                        ]),
                        UiSpacer.verticalSpace(space: 8),
                        controller.coach.classificationUser?.todaySchedule ==
                                null
                            ? 'Tidak ada jadwal'.text.make()
                            : VStack(
                                [
                                  (DateFormat('EEEE', 'ID_id')
                                          .format(DateTime.now()))
                                      .text
                                      .make(),
                                  (controller.coach.classificationUser
                                              ?.todaySchedule?.workTime ??
                                          '-')
                                      .text
                                      .semiBold
                                      .color(primaryColor)
                                      .make(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                              ),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ),
                    VStack([
                      HStack([
                        const Icon(
                          Icons.monetization_on_rounded,
                          size: 16,
                        ),
                        UiSpacer.horizontalSpace(space: 5),
                        'Harga'.text.make(),
                      ]),
                      UiSpacer.verticalSpace(space: 8),
                      (controller.coach.classificationUser?.classification
                                  ?.priceWithTax ??
                              '-')
                          .text
                          .semiBold
                          .color(primaryColor)
                          .make(),
                    ]),
                  ],
                  alignment: MainAxisAlignment.spaceAround,
                  crossAlignment: CrossAxisAlignment.center,
                  axisSize: MainAxisSize.max,
                ),
                UiSpacer.verticalSpace(),
                'Konsultasi Sekarang'
                    .text
                    .white
                    .makeCentered()
                    .continuousRectangle(
                      height: 40,
                      backgroundColor: primaryColor,
                    )
                    .onTap(controller.openConsultation),
              ]).p12().card.make(),
            UiSpacer.verticalSpace(),
            HStack([
              'Kelas Terbaru'.text.xl.semiBold.make().expand(),
            ]),
            UiSpacer.verticalSpace(space: 10),
            controller.loadingClasses.value
                ? ''.text.make().skeleton(width: 230, height: 200)
                : controller.classes.value.data!.isEmpty
                    ? 'Kelas belum tersedia'.text.makeCentered().h(230)
                    : ListView.builder(
                        itemCount: controller.classes.value.data?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ClassCard(
                          data: controller.classes.value.data![index],
                          onTap: () => controller
                              .showClass(controller.classes.value.data![index]),
                        ),
                        scrollDirection: Axis.horizontal,
                      ).h(230),
            UiSpacer.verticalSpace(),
            HStack([
              'Review'.text.xl.semiBold.make().expand(),
              'Lihat Semua'
                  .text
                  .sm
                  .color(primaryColor)
                  .make()
                  .onTap(controller.openReviews),
            ]),
            UiSpacer.verticalSpace(space: 5),
            controller.loadingReviews.value
                ? ''.text.make().skeleton(width: 230, height: 200)
                : controller.reviews.value.data!.isEmpty
                    ? 'Belum ada review'.text.makeCentered().h(230)
                    : ListView.builder(
                        itemCount: controller.reviews.value.data?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final review = controller.reviews.value.data?[index];
                          return ListTile(
                            leading: CircleAvatar(
                              foregroundImage: CachedNetworkImageProvider(
                                  review!.player!.imageProfile),
                            ),
                            title: VStack([
                              (review.player?.player?.name ?? '-')
                                  .text
                                  .sm
                                  .ellipsis
                                  .semiBold
                                  .make(),
                              RatingBar.builder(
                                initialRating: review.rating ?? 0,
                                itemCount: 5,
                                minRating: 1,
                                maxRating: 5,
                                itemSize: 15,
                                ignoreGestures: true,
                                allowHalfRating: true,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_rounded,
                                  color: starColor,
                                ),
                                glow: true,
                                onRatingUpdate: (value) {},
                              )
                            ]),
                            subtitle: (review.description ?? '-')
                                .text
                                .sm
                                .maxLines(4)
                                .ellipsis
                                .make(),
                            isThreeLine: true,
                          )
                              .w(250)
                              .backgroundColor(
                                  const Color.fromARGB(255, 231, 230, 230))
                              .cornerRadius(8)
                              .marginOnly(right: 10);
                        },
                        scrollDirection: Axis.horizontal,
                      ).h(110),
            UiSpacer.verticalSpace(),
            if (controller.userData.value.isPlayer)
              VStack([
                'Pelatih Lain'.text.xl.semiBold.make(),
                controller.coachList.value.data!.isEmpty
                    ? 'Tidak ada pelatih lain'.text.makeCentered()
                    : GridView.builder(
                        itemCount: controller.coachList.value.data?.length,
                        padding: const EdgeInsets.only(top: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 100,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final coach = controller.coachList.value.data?[index];
                          return VStack(
                            [
                              CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                    coach!.employee!.photo!),
                              ).wh(60, 60),
                              UiSpacer.verticalSpace(space: 10),
                              (coach.employee?.name ?? '-').text.ellipsis.make()
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ).onInkTap(() => controller.viewOtherCoach(coach));
                        },
                      ),
              ]),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
