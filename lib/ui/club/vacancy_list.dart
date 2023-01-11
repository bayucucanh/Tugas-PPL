import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/club/controller/vacancy.controller.dart';
import 'package:mobile_pssi/ui/club/parts/player_saved_vacancy.dart';
import 'package:mobile_pssi/ui/club/parts/selection_tab_list.dart';
import 'package:velocity_x/velocity_x.dart';

class VacancyList extends GetView<VacancyController> {
  static const routeName = '/clubs/vacancies';
  const VacancyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VacancyController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Lowongan Tersimpan'.text.make(),
      body: controller.userData.value.isCoach
          ? const SelectionTabList()
          : const PlayerSavedVacancy(),
    );
  }
}
