import 'package:avatars/avatars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/teams/controller/invite_team_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachClubInvite extends GetView<InviteTeamCoachController> {
  static const routeName = '/club/team/invite/coach';
  const CoachClubInvite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InviteTeamCoachController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Undang ke Team'.text.make(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TextFormComponent(
          controller: controller.search,
          label: 'Cari Pelatih',
          suffixIcon: IconButton(
              onPressed: controller.refreshData,
              icon: const Icon(Icons.person_search_outlined)),
          textInputAction: TextInputAction.search,
          validator: (val) {
            return null;
          },
        ).p12(),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.clubCoaches.value.data!.isEmpty
              ? 'Belum mempunyai pelatih klub, anda dapat melakukan offering untuk mendapatkan pelatih klub.'
                  .text
                  .center
                  .makeCentered()
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 245,
                  ),
                  itemBuilder: (context, index) {
                    final clubCoach = controller.clubCoaches.value.data?[index];
                    return VStack(
                      [
                        IconButton(
                          onPressed: () =>
                              controller.openDetail(clubCoach?.employee),
                          icon: const Icon(Icons.info_outline_rounded),
                        ).objectTopRight(heightFactor: 0.5),
                        clubCoach?.employee?.photo == null
                            ? Avatar(
                                name: clubCoach?.employee?.name,
                                useCache: true,
                                shape: AvatarShape.circle(50),
                              ).wh(100, 100).centered()
                            : CachedNetworkImage(
                                imageUrl: clubCoach!.employee!.photo!,
                                fit: BoxFit.cover,
                              ).wh(100, 100).cornerRadius(50).centered(),
                        UiSpacer.verticalSpace(space: 10),
                        (clubCoach?.employee?.name ?? '-').text.ellipsis.make(),
                        (clubCoach?.employee?.age ?? '-')
                            .text
                            .xs
                            .semiBold
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
                            .onInkTap(() => controller.selectCoach(clubCoach)),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ).p8();
                  },
                  itemCount: controller.clubCoaches.value.data?.length ?? 0,
                ),
        ).p12(),
      ),
    );
  }
}
