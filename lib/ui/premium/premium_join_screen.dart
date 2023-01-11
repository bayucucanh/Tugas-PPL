import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/home/parts/card.slider.dart';
import 'package:mobile_pssi/ui/premium/controller/premium_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PremiumJoinScreen extends GetView<PremiumPlayerController> {
  static const routeName = '/premium';
  const PremiumJoinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PremiumPlayerController());
    return DefaultScaffold(
      title: 'Daftar Kelas Premium'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: VStack([
        Obx(
          () => Swiper(
            autoplayDelay: const Duration(seconds: 3).inMilliseconds,
            curve: Curves.easeInExpo,
            itemCount: controller.banners?.length ?? 0,
            itemBuilder: (context, index) {
              final banner = controller.banners?[index];
              return CardSlider(banner: banner!).marginSymmetric(horizontal: 2);
            },
            allowImplicitScrolling: true,
            autoplay: false,
            pagination: DotSwiperPaginationBuilder(
              activeColor: primaryColor,
              space: 4,
              color: Colors.white.withOpacity(0.3),
            ),
          ).h(230),
        ),
        UiSpacer.verticalSpace(),
        'Tonton Semua Kelas Premium'.text.xl.semiBold.makeCentered(),
        UiSpacer.verticalSpace(space: 10),
        'Kamu akan mendapatkan benefit untuk mengambil kelas premium, berkonsultasi dengan pelatih sepakbola ternama, dan berkesempatan untuk mendaftarkan diri ke klub sepakbola yang kamu idamkan.'
            .text
            .center
            .makeCentered(),
      ]).p12().scrollVertical(),
      bottomNavigationBar: VStack([
        'Dimulai dari Rp.49.000/bulan'.text.gray500.makeCentered(),
        UiSpacer.verticalSpace(space: 10),
        'Mulai Langganan'
            .text
            .white
            .makeCentered()
            .continuousRectangle(height: 40, backgroundColor: primaryColor)
            .onTap(controller.showPackages),
        UiSpacer.verticalSpace(space: 10),
        'Tidak Sekarang'
            .text
            .color(primaryColor)
            .makeCentered()
            .onTap(controller.notNow)
      ]).p12().safeArea(),
    );
  }
}
