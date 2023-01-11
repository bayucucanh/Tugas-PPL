import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/home/controller/employee.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubInformationGraph extends GetView<EmployeeController> {
  const ClubInformationGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Informasi Klub'.text.semiBold.xl.make(),
      VStack([
        HStack([
          'Persib Bandung'.text.ellipsis.bold.maxLines(2).make().expand(),
          'Last update: 11 Feb 2022'.text.sm.color(primaryColor).make(),
        ]),
        UiSpacer.verticalSpace(),
        BarChart(controller.mainBarData()).h(200)
      ]).p12().card.make()
    ]).p12();
  }
}
