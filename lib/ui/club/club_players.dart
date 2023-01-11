import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/club/controller/club_players.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPlayers extends GetView<ClubPlayersController> {
  static const routeName = '/club/players';
  const ClubPlayers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubPlayersController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Daftar Pemain'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.players!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Klub ini belum memiliki pemain',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final clubPlayer = controller.players?[index];
                    return Slidable(
                      key: ValueKey(clubPlayer?.id),
                      enabled: controller.userData.value.isClub,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) =>
                                controller.confirmDelete(clubPlayer),
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
                              clubPlayer?.player?.photo == null
                                  ? clubPlayer!.player!.gravatar()
                                  : clubPlayer!.player!.photo!),
                        ),
                        title: (clubPlayer.player?.name ?? '-').text.make(),
                        subtitle: clubPlayer.positions!.isEmpty
                            ? 'Tidak ada jabatan'.text.make()
                            : clubPlayer.positions
                                ?.map((e) => (e.playerPosition?.name ?? '-'))
                                .join(',')
                                .text
                                .sm
                                .make(),
                        onTap: () => controller.openPlayerProfile(clubPlayer),
                      ),
                    );
                  },
                  itemCount: controller.players?.length ?? 0),
        ),
      ),
    );
  }
}
