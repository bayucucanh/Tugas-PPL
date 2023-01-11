import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/teams/controller/my_team.controller.dart';
import 'package:mobile_pssi/ui/teams/parts/image_team.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class TeamScreen extends GetView<MyTeamController> {
  static const routeName = '/teams';
  const TeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyTeamController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'My Team'.text.make(),
      actions: [
        IconButton(
          onPressed: controller.openNewTeam,
          icon: const Icon(Icons.add),
        ),
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.teams.value.data!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: 'Belum ada tim yang dibuat.',
                  textButton: 'Buat Tim Baru',
                  onTap: controller.openNewTeam,
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.teams.value.data?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (context, index) {
                    final team = controller.teams.value.data?[index];
                    return VStack([
                      (team?.name ?? '-')
                          .text
                          .semiBold
                          .maxLines(1)
                          .ellipsis
                          .makeCentered()
                          .expand(),
                      UiSpacer.verticalSpace(space: 5),
                      ImageTeam(team: team),
                      UiSpacer.verticalSpace(space: 5),
                      (team?.ageGroup?.name ?? '-')
                          .text
                          .semiBold
                          .makeCentered(),
                      HStack(
                        [
                          '${team?.totalCoach ?? 0} pelatih'
                              .text
                              .make()
                              .expand(),
                          UiSpacer.horizontalSpace(space: 5),
                          '${team?.totalPlayers ?? 0} pemain'
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
                      (team?.teamRate ?? 0)
                          .text
                          .color(team?.teamRatingColor)
                          .makeCentered(),
                    ])
                        .p12()
                        .card
                        .make()
                        .onInkTap(() => controller.openDetail(team));
                  }).p12(),
        ),
      ),
    );
  }
}
