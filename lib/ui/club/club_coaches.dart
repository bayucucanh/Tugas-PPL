import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/club/controller/club_coaches.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubCoaches extends GetView<ClubCoachesController> {
  static const routeName = '/club/coaches';
  const ClubCoaches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubCoachesController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Daftar Pelatih'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.coaches!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Klub ini belum memiliki pelatih',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final coach = controller.coaches?[index];
                    return Slidable(
                      key: ValueKey(coach?.id),
                      enabled: controller.userData.value.isClub,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) =>
                                controller.confirmDelete(coach),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Hapus',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                              coach?.employee?.photo == null
                                  ? coach!.employee!.gravatar()
                                  : coach!.employee!.photo!),
                        ),
                        title: (coach.employee?.name ?? '-').text.make(),
                        subtitle: coach.positions!.isEmpty
                            ? 'Tidak ada jabatan'.text.make()
                            : coach.positions
                                ?.map((e) => (e.coachPosition?.name ?? '-'))
                                .join(',')
                                .text
                                .sm
                                .make(),
                        onTap: () => controller.openCoachProfile(coach),
                      ),
                    );
                  },
                  itemCount: controller.coaches?.length ?? 0),
        ),
      ),
    );
  }
}
