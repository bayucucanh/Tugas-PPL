import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Tentang Kami'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: VStack([
        Image.asset(logoPath).wh(150, 150).cornerRadius(75).centered(),
        UiSpacer.verticalSpace(space: 40),
        F.title.text.xl2.semiBold.makeCentered(),
        UiSpacer.verticalSpace(space: 5),
        '+6281321500904'.text.gray500.makeCentered(),
        UiSpacer.verticalSpace(space: 5),
        'prima_academy@mail.com'.text.gray500.makeCentered(),
        UiSpacer.verticalSpace(space: 40),
        'Tentang Prima'.text.xl.semiBold.make(),
        UiSpacer.verticalSpace(),
        '${F.title} merupakan jembatan bagi seluruh pecinta sepak bola untuk bersama-sama membangun sepak bola meraih prestasi tertinggi dengan adanya e-learning, konsultasi, tes kemampuan, hingga promosi.'
            .text
            .make(),
        UiSpacer.verticalSpace(space: 15),
        HStack(
          [
            'Kebijakan Pribadi'
                .text
                .semiBold
                .color(primaryColor)
                .make()
                .onTap(() async {
              if (await canLaunchUrlString(
                  'https://kunci-transformasi-digital.github.io/privacy/')) {
                await launchUrlString(
                    'https://kunci-transformasi-digital.github.io/privacy/');
              }
            }),
            'Syarat Penggunaan'
                .text
                .semiBold
                .color(primaryColor)
                .make()
                .onTap(() async {
              String url;
              if (GetPlatform.isAndroid) {
                url =
                    'https://kunci-transformasi-digital.github.io/privacy/terms-of-use.html';
              } else {
                url =
                    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
              }

              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
            }),
          ],
          axisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.spaceEvenly,
          crossAlignment: CrossAxisAlignment.center,
        ),
      ]).safeArea().p12().scrollVertical(),
    );
  }
}
