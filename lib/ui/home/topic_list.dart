import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/shared_ui/skeleton.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TopicList extends GetView<PlayerController> {
  const TopicList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Topik'.text.semiBold.xl.make(),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.isLoadingTopic
            ? HStack([1, 2, 3]
                    .map((e) => const Skeleton(
                          height: 90,
                          width: 90,
                          radius: 20,
                        ).px8())
                    .toList())
                .h(120)
            : controller.topics.value.data!.isEmpty
                ? 'Topik belum tersedia'.text.makeCentered().h(230)
                : ListView.builder(
                    itemCount: controller.topics.value.data?.length,
                    shrinkWrap: true,
                    itemExtent: 90,
                    itemBuilder: (context, index) {
                      final topic = controller.topics.value.data?[index];
                      return VStack(
                        [
                          topic?.image != null
                              ? ImageCustom(
                                  url: topic!.image!,
                                  blurhash: topic.blurhash,
                                )
                                  .wh(80, 80)
                                  .backgroundColor(Vx.gray400)
                                  .cornerRadius(20)
                              : 'No Image'
                                  .text
                                  .white
                                  .xs
                                  .center
                                  .makeCentered()
                                  .wh(80, 80)
                                  .backgroundColor(Vx.gray400)
                                  .cornerRadius(20),
                          UiSpacer.verticalSpace(space: 5),
                          (topic?.name ?? '-').text.make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ).onTap(() => controller.openList(category: topic));
                    },
                    scrollDirection: Axis.horizontal,
                  ).h(120),
      ),
    ]).px12().pOnly(top: 12);
  }
}
