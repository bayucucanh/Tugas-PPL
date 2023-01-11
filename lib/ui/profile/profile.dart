import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/profile/controller/profile.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends GetView<ProfileController> {
  static const routeName = '/profile';
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return DefaultScaffold(
      title: 'Profil'.text.white.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: Obx(
        () => VStack([
          HStack(
            [
              CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                    controller.profile.value.photo == null
                        ? controller.userData.value.gravatar()
                        : controller.profile.value.photo.toString()),
              ).wh(80, 80),
              UiSpacer.horizontalSpace(space: 10),
              VStack([
                (controller.profile.value.name ?? '-').text.semiBold.lg.make(),
                UiSpacer.verticalSpace(space: 2),
                (controller.userData.value.phoneNumber ?? '-')
                    .text
                    .gray500
                    .make(),
                UiSpacer.verticalSpace(space: 2),
                (controller.userData.value.email ?? '-').text.gray500.make(),
              ]).expand(),
              if (controller.userData.value.isPlayer)
                const Icon(Icons.bar_chart_rounded)
            ],
          ).onTap(controller.openProfileDetail),
          UiSpacer.verticalSpace(),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: 'Data Pribadi Akun'.text.make(),
            subtitle: 'Personal Data & Verifikasi Data'.text.sm.make(),
            onTap: controller.openPersonalData,
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: 'Data Keamanan Akun'.text.make(),
            subtitle:
                'Ubah Kata Sandi, Hapus Akun, dan Hubungkan ke Media Sosial'
                    .text
                    .sm
                    .make(),
            onTap: controller.openSecurity,
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions_rounded),
            title: 'Berlangganan'.text.make(),
            subtitle: 'Langganan Aktif & Non-Aktif'.text.sm.make(),
            onTap: controller.openMySubscriptions,
          ),
          ListTile(
            leading: const Icon(Icons.payment_rounded),
            title: 'Riwayat Pembayaran'.text.make(),
            onTap: controller.openPaymentHistory,
            subtitle: 'Riwayat pembayaran'.text.sm.make(),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: 'Bantuan'.text.make(),
            onTap: controller.openHelp,
            subtitle: 'Bantuan aplikasi prima academy'.text.sm.make(),
          ),
          ListTile(
            leading: const Icon(Icons.group_rounded),
            title: 'Tentang Kami'.text.make(),
            onTap: controller.openAbout,
            subtitle: 'Tentang Kami'.text.sm.make(),
          ),
          ListTile(
            leading: const Icon(Icons.phone_android_rounded),
            title: 'Versi Aplikasi'.text.make(),
            trailing: controller.isGettingAppInfo.value
                ? const CircularProgressIndicator()
                : 'v${controller.appVersion.value}'.text.italic.sm.make(),
            subtitle: 'Versi aplikasi'.text.sm.make(),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: 'Logout'.text.make(),
            onTap: controller.logout,
          ),
        ]).p8().scrollVertical(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openCS,
        label: HStack([
          const FaIcon(FontAwesomeIcons.whatsapp),
          UiSpacer.horizontalSpace(space: 5),
          'Hubungi CS'.text.make()
        ]),
        isExtended: true,
        tooltip: 'Customer Service',
      ),
    );
  }
}
