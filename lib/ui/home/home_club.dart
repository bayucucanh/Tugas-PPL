import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/home/club_event_list.dart';
import 'package:mobile_pssi/ui/home/competition_list.dart';
import 'package:mobile_pssi/ui/home/controller/club.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeClub extends GetView<ClubController> {
  const HomeClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubController());
    return VStack([
      UiSpacer.verticalSpace(),
      HStack(
        [
          const Icon(
            Icons.shopping_bag_rounded,
            size: 38,
            color: primaryColor,
          ),
          UiSpacer.horizontalSpace(space: 10),
          VStack([
            '${F.title} Store'.text.xl.semiBold.make(),
            UiSpacer.verticalSpace(space: 5),
            'Dapatkan kebutuhan klub mu dengan membeli paket premium disini.'
                .text
                .gray500
                .sm
                .make(),
          ]).expand()
        ],
        axisSize: MainAxisSize.max,
      ).p12().card.make().onTap(controller.openClubStore).p12(),
      UiSpacer.verticalSpace(),
      const ClubEventList(),
      UiSpacer.verticalSpace(),
      const CompetitionList(),
      UiSpacer.verticalSpace(),
      ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: const Icon(
              Icons.groups_rounded,
              color: Colors.white,
              size: 36,
            ),
            title: 'My Team'.text.semiBold.white.make(),
            subtitle: 'Mari lihat performa tim saya'.text.white.make(),
            tileColor: Colors.blueAccent.shade400,
            onTap: controller.openMyTeams,
          ),
          ListTile(
            leading: const Icon(
              Icons.transfer_within_a_station_rounded,
              color: Colors.white,
              size: 36,
            ),
            title: 'Transfermarket'.text.semiBold.white.make(),
            subtitle: 'Promosikan klub anda'.text.white.make(),
            tileColor: primaryColor,
            trailing: const Icon(Icons.star_rate_rounded),
            onTap: controller.openTransfermarket,
          ),
          ListTile(
            leading: const Icon(
              Icons.person_search_rounded,
              color: Colors.white,
              size: 36,
            ),
            title: 'Player Scouting'.text.semiBold.white.make(),
            subtitle:
                'Mari cari pemain yang cocok untuk tim anda.'.text.white.make(),
            tileColor: Colors.green.shade500,
            onTap: controller.openPlayerScouting,
            trailing: const Icon(Icons.star_rate_rounded),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_search_rounded,
              color: Colors.white,
              size: 36,
            ),
            title: 'Coach Scouting'.text.semiBold.white.make(),
            subtitle: 'Mari cari pelatih yang cocok untuk tim anda.'
                .text
                .white
                .make(),
            onTap: controller.openCoachScouting,
            tileColor: Colors.amber.shade800,
            trailing: const Icon(Icons.star_rate_rounded),
          ),
        ],
      ),
      UiSpacer.verticalSpace(space: 40),
    ]);
  }
}
