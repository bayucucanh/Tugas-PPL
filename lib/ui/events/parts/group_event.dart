import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/events/controller/event_participants.controller.dart';
import 'package:mobile_pssi/ui/teams/parts/image_team.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class GroupEvent extends GetView<EventParticipantsController> {
  const GroupEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: VStack([
        const TabBar(
          tabs: [
            Tab(
              text: 'Tim Klub',
            ),
            Tab(
              text: 'Solo',
            ),
          ],
        ),
        TabBarView(children: [
          SmartRefresher(
            controller: controller.refreshControllers[0],
            enablePullDown: true,
            enablePullUp: true,
            onLoading: () => controller.loadMore(
                controller.refreshControllers[0],
                filter: LoadFilter.group),
            onRefresh: () => controller.refreshData(
                controller.refreshControllers[0],
                filter: LoadFilter.group),
            child: Obx(
              () => controller.groupParticipants!.isEmpty == true
                  ? const EmptyWithButton(
                      emptyMessage: 'Belum ada klub tim mendaftar',
                      showImage: true,
                      showButton: false,
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.groupParticipants?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (context, index) {
                        final group = controller.groupParticipants?[index];
                        return VStack([
                          (group?.team?.name ?? '-')
                              .text
                              .semiBold
                              .maxLines(1)
                              .ellipsis
                              .makeCentered()
                              .expand(),
                          UiSpacer.verticalSpace(space: 5),
                          ImageTeam(team: group?.team),
                          UiSpacer.verticalSpace(space: 5),
                          (group?.team?.ageGroup?.name ?? '-')
                              .text
                              .semiBold
                              .makeCentered(),
                          HStack(
                            [
                              '${group?.team?.totalCoach ?? 0} pelatih'
                                  .text
                                  .make()
                                  .expand(),
                              UiSpacer.horizontalSpace(space: 5),
                              '${group?.team?.totalPlayers ?? 0} pemain'
                                  .text
                                  .make()
                                  .expand(),
                            ],
                            alignment: MainAxisAlignment.spaceEvenly,
                            crossAlignment: CrossAxisAlignment.center,
                            axisSize: MainAxisSize.max,
                          ).expand(),
                          UiSpacer.divider(height: 10),
                          'Team Rating'.text.makeCentered(),
                          (group?.team?.teamRate ?? 0)
                              .text
                              .color(group?.team?.teamRatingColor)
                              .makeCentered(),
                        ])
                            .p12()
                            .card
                            .make()
                            .onInkTap(() => controller.openDetail(group?.team));
                      }).p12(),
            ),
          ),
          SmartRefresher(
            controller: controller.refreshControllers[1],
            enablePullDown: true,
            enablePullUp: true,
            onLoading: () => controller.loadMore(
                controller.refreshControllers[1],
                filter: LoadFilter.solo),
            onRefresh: () => controller.refreshData(
                controller.refreshControllers[1],
                filter: LoadFilter.solo),
            child: Obx(
              () => controller.soloParticipants!.isEmpty == true
                  ? const EmptyWithButton(
                      emptyMessage: 'Belum ada peserta mendaftar',
                      showImage: true,
                      showButton: false,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final participant = controller.soloParticipants?[index];
                        return ListTile(
                          leading: CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                                participant!.user!.imageProfile),
                          ),
                          title: (participant.user?.profile?.name ?? '-')
                              .text
                              .make(),
                          subtitle: (participant.code ?? '-').text.make().tooltip(
                              'Kode Registrasi : ${participant.code ?? '-'}'),
                        );
                      },
                      separatorBuilder: (context, index) => UiSpacer.divider(),
                      itemCount: controller.soloParticipants?.length ?? 0,
                    ),
            ),
          ),
        ]).expand(),
      ]),
    );
  }
}
