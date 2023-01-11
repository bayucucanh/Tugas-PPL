import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/home/controller/home_controller.dart';
import 'package:mobile_pssi/ui/home/dashboard_stat.dart';
import 'package:mobile_pssi/ui/home/home_club.dart';
import 'package:mobile_pssi/ui/home/home_employee.dart';
import 'package:mobile_pssi/ui/home/home_player.dart';
import 'package:mobile_pssi/ui/home/parts/card.slider.dart';
import 'package:mobile_pssi/ui/home/parts/search_home.dart';
import 'package:mobile_pssi/utils/greetings.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends GetView<HomeController> {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return DefaultScaffold(
      showAppBar: false,
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        scrollController: controller.scrollController,
        controller: controller.refreshController,
        enablePullDown: true,
        onRefresh: controller.refreshHome,
        child: Obx(
          () => VStack([
            VStack(
              [
                ZStack(
                  [
                    VxBox()
                        .bgImage(const DecorationImage(
                            image: AssetImage(homeBackground),
                            fit: BoxFit.fill))
                        .height(230)
                        .color(primaryColor)
                        .bottomRounded(value: 25)
                        .make(),
                    HStack(
                      [
                        IconButton(
                          onPressed: controller.showProfileDialog,
                          icon: const Icon(Icons.menu_rounded, color: Vx.white),
                        ),
                        VStack([
                          'Selamat ${greetings()}'
                              .text
                              .white
                              .light
                              .ellipsis
                              .sm
                              .make(),
                          (controller.userData.value.profile?.name ?? '-')
                              .text
                              .white
                              .ellipsis
                              .sm
                              .maxLines(1)
                              .semiBold
                              .make()
                              .w(80),
                        ]).px8(),
                        UiSpacer.horizontalSpace(space: 10),
                        Image.asset(whiteLogoPath,
                                semanticLabel: '${F.title} White Logo')
                            .w(140)
                            .h(50)
                            .expand(),
                        UiSpacer.horizontalSpace(space: 10),
                        HStack(
                          [
                            IconButton(
                              onPressed: controller.openProfileDetail,
                              icon: CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.5),
                                foregroundImage: CachedNetworkImageProvider(
                                  controller.userData.value.profile?.photo ==
                                          null
                                      ? controller.userData.value.gravatar()
                                      : controller
                                          .userData.value.profile!.photo!,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: controller.openNotification,
                              icon: CircleAvatar(
                                backgroundColor: Colors.red.withOpacity(0.4),
                                child: const Icon(
                                  Icons.notifications_active_rounded,
                                  color: Colors.white,
                                ),
                              ).badge(
                                limit: true,
                                color: primaryColor,
                                count: controller.unreadMessage.value,
                              ),
                            ),
                          ],
                        )
                      ],
                      alignment: MainAxisAlignment.spaceBetween,
                    ).wFull(context).positioned(top: 60),
                    if (controller.userData.value.isPlayer)
                      const SearchHome()
                          .h(45)
                          .p12()
                          .wFull(context)
                          .positioned(top: 110, isFilled: true),
                    controller.userData.value.hasRole('administrator')
                        ? const DashboardStat().positioned(top: 110)
                        : controller.isLoadingBanner == true
                            ? ''
                                .text
                                .make()
                                .skeleton(
                                  width: Get.width,
                                  height: 180,
                                  borderRadius: BorderRadius.circular(10),
                                )
                                .p12()
                                .positioned(
                                  top: controller.userData.value.isPlayer
                                      ? 175
                                      : 120,
                                )
                            : Swiper(
                                autoplayDelay:
                                    const Duration(seconds: 10).inMilliseconds,
                                curve: Curves.easeInExpo,
                                controller: SwiperController(),
                                onTap: (index) => controller
                                    .openLink(controller.banners?[index].link),
                                duration:
                                    const Duration(seconds: 1).inMilliseconds,
                                itemCount: controller.banners?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final banner = controller.banners?[index];
                                  return CardSlider(banner: banner!);
                                },
                                autoplay: controller.banners?.length == 1
                                    ? false
                                    : true,
                                pagination: DotSwiperPaginationBuilder(
                                  activeColor: primaryColor,
                                  space: 4,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ).h(180).p12().wFull(context).positioned(
                                  top: controller.userData.value.isPlayer
                                      ? 175
                                      : 120,
                                ),
                  ],
                  fit: StackFit.loose,
                ).h(320),
                UiSpacer.verticalSpace(
                    space: controller.userData.value.isPlayer ? 50 : 0),
                // const SecondNavbar(),
                controller.userData.value.isPlayer
                    ? const HomePlayer()
                    : controller.userData.value.isClub
                        ? const HomeClub()
                        : const HomeEmployee(),
              ],
              axisSize: MainAxisSize.min,
            ),
          ]).scrollVertical(),
        ),
      ),
    );
  }
}
