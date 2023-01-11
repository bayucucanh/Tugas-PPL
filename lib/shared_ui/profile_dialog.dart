import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/home/controller/menu.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileDialog extends StatelessWidget {
  final MenuController vm;
  const ProfileDialog({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Dialog(
        backgroundColor: const Color.fromARGB(255, 42, 42, 42),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: VStack([
          HStack(
            [
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ).pOnly(left: 5, right: 5),
              F.title.text.white.start.bold.make().expand(),
            ],
            axisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.center,
          ),
          UiSpacer.verticalSpace(space: 10),
          ListTile(
            leading: CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(
                vm.userData.value.profile?.photo == null
                    ? vm.userData.value.gravatar()
                    : vm.userData.value.profile!.photo!,
              ),
            ),
            title: (vm.userData.value.profile?.name ?? '-')
                .text
                .sm
                .semiBold
                .white
                .make(),
            subtitle: (vm.userData.value.email ?? '-')
                .text
                .color(Colors.grey)
                .sm
                .make(),
            onTap: vm.openProfileDetail,
          ),
          UiSpacer.divider(),
          ListView.builder(
            itemCount: vm.profileMenu.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => vm.profileMenu[index],
          ).h(300),
          UiSpacer.divider(),
          // HStack(
          //   [
          //     'Kebijakan Pribadi'.text.xs.white.make(),
          //     'Persyaratan Layanan'.text.xs.white.make(),
          //   ],
          //   axisSize: MainAxisSize.max,
          //   alignment: MainAxisAlignment.spaceEvenly,
          // ).p12()
        ]),
      ),
    );
  }
}
