import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/watch/controller/watch.controller.dart';
import 'package:mobile_pssi/ui/watch/parts/video.card.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoList extends GetView<WatchController> {
  const VideoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.videos.isEmpty
          ? 'Belum ada video tersedia'.text.makeCentered()
          : ListView.builder(
              itemCount: controller.videos.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => Obx(
                () => VideoCard(
                  classDetail: controller.classDetail,
                  video: controller.videos[index],
                  number: (index + 1),
                  onTap: () => controller.changeVideo(index),
                  currentWatch: index == controller.currentWatch.value,
                  checked: (value) =>
                      controller.checkVideo(value, controller.videos[index]),
                ),
              ),
            ).p8(),
    );
  }
}
