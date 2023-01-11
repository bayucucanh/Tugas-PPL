import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/teams/controller/team_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class TeamDetail extends GetView<TeamDetailController> {
  static const routeName = '/team/detail';
  const TeamDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TeamDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: (controller.team.value.name ?? '-').text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          onRefresh: controller.refreshData,
          child: VStack([
            VStack([
              HStack([
                'Informasi Tim'.text.xl.semiBold.white.make().expand(),
                IconButton(
                  onPressed: controller.openEditTeam,
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: Vx.white,
                  ),
                  tooltip: 'Ubah Tim',
                )
              ]),
              UiSpacer.divider(height: 10),
              'Nama Tim : ${controller.team.value.name ?? '-'}'
                  .text
                  .white
                  .make(),
              'Kelompok Usia : ${controller.team.value.ageGroup?.name ?? '-'}'
                  .text
                  .white
                  .make(),
              'Jenis Kelamin : ${controller.team.value.gender?.name ?? '-'}'
                  .text
                  .white
                  .make(),
            ]).p8().card.color(Colors.green).make().wFull(context),
            UiSpacer.verticalSpace(),
            HStack([
              'Pelatih'.text.semiBold.xl.make().expand(),
              'Undang'
                  .text
                  .color(primaryColor)
                  .make()
                  .onTap(controller.openCoachInvite),
            ]),
            UiSpacer.verticalSpace(),
            controller.team.value.coaches == null ||
                    controller.team.value.coaches!.isEmpty
                ? EmptyWithButton(
                    emptyMessage: 'Belum ada pelatih pada tim ini',
                    textButton: 'Undang Pelatih',
                    onTap: controller.openCoachInvite,
                  )
                : ListView.builder(
                    itemCount: controller.team.value.coaches?.length ?? 0,
                    itemBuilder: (context, index) {
                      final coachTeam = controller.team.value.coaches?[index];
                      return ListTile(
                        onTap: () =>
                            controller.openDetailCoach(coachTeam?.coach),
                        leading: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                            coachTeam?.coach?.photo == null
                                ? coachTeam!.coach!.gravatar()
                                : coachTeam!.coach!.photo!,
                          ),
                        ),
                        title: (coachTeam.coach?.name ?? '-').text.make(),
                        trailing: coachTeam.status == 0
                            ? 'Batal'.text.color(primaryColor).make().onTap(
                                () => controller.cancelInviteCoach(coachTeam))
                            : 'Keluarkan'.text.color(primaryColor).make().onTap(
                                () => controller.cancelCoachDialog(coachTeam)),
                      );
                    },
                  ).h(250),
            UiSpacer.verticalSpace(),
            HStack([
              'Pemain'.text.semiBold.xl.make().expand(),
              'Undang'
                  .text
                  .color(primaryColor)
                  .make()
                  .onTap(controller.openPlayerInvite),
            ]),
            controller.team.value.players == null ||
                    controller.team.value.players!.isEmpty
                ? EmptyWithButton(
                    emptyMessage: 'Belum ada pemain pada tim ini',
                    textButton: 'Undang Pemain',
                    onTap: controller.openPlayerInvite,
                  )
                : ListView.builder(
                    itemCount: controller.team.value.players?.length ?? 0,
                    itemBuilder: (context, index) {
                      final playerTeam = controller.team.value.players?[index];
                      return ListTile(
                        onTap: () => controller
                            .openDetailPlayer(playerTeam?.clubPlayer!.player),
                        leading: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                            playerTeam?.clubPlayer?.player?.photo == null
                                ? playerTeam!.clubPlayer!.player!.gravatar()
                                : playerTeam!.clubPlayer!.player!.photo!,
                          ),
                        ),
                        title: (playerTeam.clubPlayer?.player?.name ?? '-')
                            .text
                            .make(),
                        trailing: playerTeam.status == 0
                            ? 'Batal'.text.color(primaryColor).make().onTap(
                                () => controller.cancelInvitePlayer(playerTeam))
                            : 'Keluarkan'.text.color(primaryColor).make().onTap(
                                () =>
                                    controller.cancelInvitePlayer(playerTeam)),
                      );
                    },
                  ).h(250),
          ]).p8().scrollVertical(),
        ),
      ),
    );
  }
}
