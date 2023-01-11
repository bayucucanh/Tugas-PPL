import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/events/controller/team_event_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:velocity_x/velocity_x.dart';

class EventTeamDetail extends GetView<TeamEventDetailController> {
  static const routeName = '/event/team/detail';
  const EventTeamDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TeamEventDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: (controller.team.value.name ?? '-').text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          onRefresh: controller.refreshData,
          child: VStack([
            HStack([
              'Pelatih'.text.semiBold.xl.make().expand(),
            ]),
            UiSpacer.verticalSpace(),
            controller.team.value.coaches == null ||
                    controller.team.value.coaches!.isEmpty
                ? const EmptyWithButton(
                    emptyMessage: 'Belum ada pelatih pada tim ini',
                    showButton: false,
                    showImage: false,
                  )
                : ListView.builder(
                    itemCount: controller.team.value.coaches?.length ?? 0,
                    itemBuilder: (context, index) {
                      final coachTeam = controller.team.value.coaches?[index];
                      return ListTile(
                        leading: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                            coachTeam?.coach?.photo == null
                                ? coachTeam?.coach?.gravatar() ??
                                    Gravatar('U').imageUrl(
                                      size: 150,
                                      defaultImage: GravatarImage.retro,
                                      rating: GravatarRating.pg,
                                      fileExtension: true,
                                    )
                                : coachTeam!.coach!.photo!,
                          ),
                          onForegroundImageError: (exception, stackTrace) =>
                              OctoError.icon(color: Colors.red),
                        ),
                        title: (coachTeam?.coach?.name ?? '-').text.make(),
                        trailing: coachTeam?.coach?.user?.ktp == null
                            ? null
                            : IconButton(
                                onPressed: coachTeam?.coach?.user?.ktp == null
                                    ? null
                                    : () => controller
                                        .openKtp(coachTeam?.coach?.user),
                                icon: const Icon(Icons.file_copy_rounded),
                                color: primaryColor,
                              ),
                      );
                    },
                  ).h(250),
            UiSpacer.verticalSpace(),
            HStack([
              'Pemain'.text.semiBold.xl.make().expand(),
            ]),
            controller.team.value.players == null ||
                    controller.team.value.players!.isEmpty
                ? const EmptyWithButton(
                    emptyMessage: 'Belum ada pemain pada tim ini',
                    showButton: false,
                    showImage: false,
                  )
                : ListView.builder(
                    itemCount: controller.team.value.players?.length ?? 0,
                    itemBuilder: (context, index) {
                      final playerTeam = controller.team.value.players?[index];
                      return ListTile(
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
                          trailing: IconButton(
                              onPressed: () => controller.openCV(
                                  playerTeam.clubPlayer?.player?.userId),
                              icon: const Icon(
                                Icons.file_copy_rounded,
                                color: primaryColor,
                              )));
                    },
                  ).h(250),
          ]).p8().scrollVertical(),
        ),
      ),
    );
  }
}
