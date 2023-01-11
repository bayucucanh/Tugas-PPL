import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/ui/academy_partner/apply_partner.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/ui/home/controller/menu.controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:velocity_x/velocity_x.dart';

class EmployeeController extends BaseController {
  final menuController = Get.put(MenuController());
  final _eventRequest = EventRequest();
  final _eventList = Resource<List<Event>>(data: []).obs;
  final _eventLoading = true.obs;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() {
    getUserData();
    _getEventList();
  }

  _getEventList() async {
    try {
      _eventList(await _eventRequest.gets(limit: 5, target: 'pelatih'));
      _eventLoading(false);
    } on Exception catch (_) {}
  }

  // openPartnerDialog() {
  //   getBottomSheet(
  //     VStack([
  //       'Bergabung menjadi Prima Academy Partner'.text.semiBold.xl2.make(),
  //       'Pelatih yang tergabung dalam prima academy akan mendapatkan banyak benefit, daftarkan sekarang juga.'
  //           .text
  //           .sm
  //           .gray500
  //           .make(),
  //       UiSpacer.verticalSpace(),
  //       ListTile(
  //         leading: const Icon(
  //           Icons.video_camera_front_rounded,
  //           size: 36,
  //         ),
  //         title: 'Daftar Menjadi Konten Kreator'.text.semiBold.make(),
  //         subtitle: 'Pantau terus ya kita akan segera datang.'.text.sm.make(),
  //       ),
  //       ListTile(
  //         leading: const Icon(
  //           Icons.co_present_outlined,
  //           size: 36,
  //           color: primaryColor,
  //         ),
  //         title: 'Daftar Menjadi Konsultan'.text.semiBold.make(),
  //         subtitle:
  //             'Daftarkan diri anda menjadi seorang konsultan sekarang juga. Dapatkan income lebih banyak dengan melakukan konsultasi dengan para pemain.'
  //                 .text
  //                 .sm
  //                 .make(),
  //         onTap: _registerAsConsultant,
  //       ),
  //       UiSpacer.verticalSpace(space: 40),
  //     ]).p12(),
  //   );
  // }

  openEvent(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  registerPartner() async {
    try {
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      Get.toNamed(ApplyPartner.routeName);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: primaryColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTopTitles,
            reservedSize: 38,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = primaryColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: primaryColor.withOpacity(0.4),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5);
          case 1:
            return makeGroupData(1, 6.5);
          case 2:
            return makeGroupData(2, 5);
          case 3:
            return makeGroupData(3, 7.5);
          case 4:
            return makeGroupData(4, 9);
          case 5:
            return makeGroupData(5, 11.5);
          case 6:
            return makeGroupData(6, 6.5);
          default:
            return throw Error();
        }
      });

  Widget getTopTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = '5'.text.textStyle(style).make();
        break;
      case 1:
        text = '6.5'.text.textStyle(style).make();
        break;
      case 2:
        text = '5'.text.textStyle(style).make();
        break;
      case 3:
        text = '7.5'.text.textStyle(style).make();
        break;
      case 4:
        text = '9'.text.textStyle(style).make();
        break;
      case 5:
        text = '11.5'.text.textStyle(style).make();
        break;
      case 6:
        text = '6.5'.text.textStyle(style).make();
        break;
      default:
        text = ''.text.textStyle(style).make();
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  bool get isLoadingEvent => _eventLoading.value;
  List<Event>? get events => _eventList.value.data;
}
