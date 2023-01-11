import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/home/class_list.dart';
import 'package:mobile_pssi/ui/home/coach.list.dart';
import 'package:mobile_pssi/ui/home/competition_list.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/ui/home/current-watch.list.dart';
import 'package:mobile_pssi/ui/home/parts/premium.button.dart';
import 'package:mobile_pssi/ui/home/player_event_list.dart';
import 'package:mobile_pssi/ui/home/topic_list.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePlayer extends GetView<PlayerController> {
  const HomePlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerController());
    return Obx(
      () => VStack([
        if (controller.isPremiumSubscribe.value == false) const PremiumButton(),
        const TopicList(),
        const ClassList(),
        const PlayerEventList(),
        const CompetitionList(),
        const CurrentWatchList(),
        const CoachList(),
      ]),
    );
  }
}
