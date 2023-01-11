import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/events/controller/event_participants.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SoloEvent extends GetView<EventParticipantsController> {
  const SoloEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.refreshControllers[1],
      enablePullDown: true,
      enablePullUp: true,
      onLoading: () => controller.loadMore(controller.refreshControllers[1]),
      onRefresh: () => controller.refreshData(controller.refreshControllers[1]),
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
                    title: (participant.user?.profile?.name ?? '-').text.make(),
                    subtitle: (participant.code ?? '-').text.make().tooltip(
                        'Kode Registrasi : ${participant.code ?? '-'}'),
                  );
                },
                separatorBuilder: (context, index) => UiSpacer.divider(),
                itemCount: controller.soloParticipants?.length ?? 0,
              ),
      ),
    );
  }
}
