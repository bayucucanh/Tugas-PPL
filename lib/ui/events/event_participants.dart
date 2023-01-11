import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/events/controller/event_participants.controller.dart';
import 'package:mobile_pssi/ui/events/parts/group_event.dart';
import 'package:mobile_pssi/ui/events/parts/solo_event.dart';
import 'package:velocity_x/velocity_x.dart';

class EventParticipants extends GetView<EventParticipantsController> {
  static const routeName = '/events/participants';
  const EventParticipants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EventParticipantsController());
    return DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Peserta Event'.text.make(),
        body: controller.event?.target == null ||
                controller.event!.target!.contains('klub')
            ? const GroupEvent()
            : const SoloEvent());
  }
}
