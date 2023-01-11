import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/saved_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SavedPlayer extends GetView<SavedPlayerController> {
  static const routeName = '/scouting/saved/player';
  const SavedPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SavedPlayerController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Pemain Tersimpan'.text.make(),
      body: Obx(
        () => controller.players.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Tidak memiliki pemain tersimpan.',
                onTap: controller.goScoutingPlayer,
                textButton: 'Cari Pemain',
              )
            : ListView.builder(
                itemCount: controller.players.length,
                itemBuilder: (context, index) {
                  final player = controller.players[index];
                  return Slidable(
                    key: ValueKey(player.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.deleteSavedPlayer(player),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: HStack([
                      VStack(
                        [
                          CachedNetworkImage(
                            imageUrl: player.photo == null
                                ? player.gravatar()
                                : player.photo!,
                            fit: BoxFit.cover,
                          ).wh(75, 75).cornerRadius(80),
                          UiSpacer.verticalSpace(space: 10),
                          'Rating'.text.semiBold.make(),
                          (player.performanceTestVerification?.avgResults
                                      ?.toStringAsFixed(1) ??
                                  '-')
                              .text
                              .lg
                              .semiBold
                              .color(player
                                  .performanceTestVerification?.scoreColor)
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                      UiSpacer.horizontalSpace(),
                      VStack(
                        [
                          (player.name ?? '-').text.lg.ellipsis.semiBold.make(),
                          ('${player.height?.value} ${player.height?.unit} / ${player.weight?.value} ${player.weight?.unit}')
                              .text
                              .make(),
                        ],
                        alignment: MainAxisAlignment.start,
                        crossAlignment: CrossAxisAlignment.start,
                      ).expand(),
                    ]).p8().onInkTap(() => controller.getDetail(player)),
                  );
                }),
      ),
    );
  }
}
