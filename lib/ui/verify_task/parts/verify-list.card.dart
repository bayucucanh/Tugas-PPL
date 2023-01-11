import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyListCard extends StatelessWidget {
  final VerifyTask task;
  const VerifyListCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack(
        [
          task.learningTask?.thumbnailVideo == null
              ? const Icon(Icons.image)
                  .box
                  .gray300
                  .make()
                  .wh(120, 100)
                  .cornerRadius(10)
              : CachedNetworkImage(
                  imageUrl: task.learningTask!.thumbnailVideo!,
                ).wh(120, 100).cornerRadius(10),
          UiSpacer.horizontalSpace(space: 10),
          VStack(
            [
              (task.learningTask?.learning?.name ?? '-').text.semiBold.make(),
              HStack([
                const Icon(
                  Icons.face,
                  size: 12,
                ),
                UiSpacer.horizontalSpace(space: 5),
                (task.learningTask?.player?.name ?? '-').text.sm.gray500.make(),
              ]),
              HStack([
                (task.status?.id == 1
                        ? 'Belum Diverifikasi'
                        : task.status?.name ?? '-')
                    .text
                    .sm
                    .color(task.status!.getStatusColor()!)
                    .make(),
                UiSpacer.horizontalSpace(space: 5),
                (task.moment ?? '-').text.sm.gray500.make(),
              ]),
            ],
            alignment: MainAxisAlignment.start,
            crossAlignment: CrossAxisAlignment.start,
          ).expand(),
        ],
        alignment: MainAxisAlignment.start,
      ),
    ]);
  }
}
