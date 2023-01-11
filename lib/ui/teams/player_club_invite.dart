import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/teams/controller/invite_team_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerClubInvite extends GetView<InviteTeamPlayerController> {
  static const routeName = '/club/team/invite/player';
  const PlayerClubInvite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InviteTeamPlayerController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Undang ke Team'.text.make(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: TextFormComponent(
          controller: controller.search,
          label: 'Cari Pemain',
          validator: (val) {
            return null;
          },
          suffixIcon: IconButton(
              onPressed: controller.refreshData,
              icon: const Icon(Icons.person_search_outlined)),
          textInputAction: TextInputAction.search,
        ).p12(),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.clubPlayers.value.data!.isEmpty
              ? 'Belum mempunyai pemain klub, anda dapat melakukan offering untuk mendapatkan pemain klub.'
                  .text
                  .center
                  .makeCentered()
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 245,
                  ),
                  itemBuilder: (context, index) {
                    final clubPlayer =
                        controller.clubPlayers.value.data?[index];
                    return VStack(
                      [
                        IconButton(
                          onPressed: () =>
                              controller.openDetail(clubPlayer?.player),
                          icon: const Icon(Icons.info_outline_rounded),
                        ).objectTopRight(heightFactor: 0.5),
                        clubPlayer?.player?.photo == null
                            ? Avatar(
                                name: clubPlayer?.player?.name,
                                useCache: true,
                                shape: AvatarShape.circle(50),
                              ).wh(100, 100).centered()
                            : CachedNetworkImage(
                                imageUrl: clubPlayer!.player!.photo!,
                                fit: BoxFit.cover,
                              ).wh(100, 100).cornerRadius(50).centered(),
                        UiSpacer.verticalSpace(space: 10),
                        (clubPlayer?.player?.name ?? '-').text.ellipsis.make(),
                        (clubPlayer?.player?.age ?? '-')
                            .text
                            .xs
                            .semiBold
                            .make(),
                        'Rating : ${clubPlayer?.player?.performanceTestVerification?.avgResults ?? '-'}'
                            .text
                            .make(),
                        UiSpacer.verticalSpace(space: 10),
                        'Undang'
                            .text
                            .white
                            .makeCentered()
                            .continuousRectangle(
                              height: 30,
                              backgroundColor: primaryColor,
                            )
                            .onInkTap(
                                () => controller.selectPlayer(clubPlayer)),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ).p8();
                  },
                  itemCount: controller.clubPlayers.value.data?.length ?? 0,
                ),
        ).p12(),
      ),
    );
  }
}
