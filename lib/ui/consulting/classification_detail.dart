import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/extensions/format_currency.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/consulting/controller/classification_detail.controller.dart';
import 'package:mobile_pssi/ui/consulting/parts/work_time_schedule.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassificationDetail extends GetView<ClassificationDetailController> {
  static const routeName = '/consultation/classification';
  const ClassificationDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClassificationDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Detil Konsultasi'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.classificationUser?.status == false
              ? 'Fitur konsultasi Anda telah dinonaktifkan oleh ${F.title}.'
                  .text
                  .center
                  .makeCentered()
              : VStack([
                  HStack([
                    Image.asset('assets/images/mascot-running.png').w(60),
                    UiSpacer.horizontalSpace(),
                    VStack([
                      'Anda sudah menghasilkan :'.text.white.sm.make(),
                      '${controller.classificationUser?.incomes?.toCurrency() ?? 'Rp 0'} selama menjadi ${F.title}'
                          .text
                          .sm
                          .white
                          .make(),
                    ]).expand(),
                  ])
                      .box
                      .color(const Color(0xff900101))
                      .roundedSM
                      .make()
                      .wFull(context),
                  VStack([
                    'Data Klasifikasi'.text.lg.semiBold.make(),
                    UiSpacer.verticalSpace(space: 10),
                    'Klasifikasi : ${controller.classificationUser?.classification?.name ?? '-'}'
                        .text
                        .make(),
                    'Harga per konsultasi: ${controller.classificationUser?.classification?.priceWithTax ?? '-'} (Harga sudah termasuk pajak 11%)'
                        .text
                        .xs
                        .make(),
                  ]).p12().card.make().wFull(context),
                  VStack([
                    'Level Up Progress'.text.semiBold.make(),
                    UiSpacer.verticalSpace(space: 10),
                    HStack([
                      (controller.classificationUser?.classification
                                  ?.passingGrade ??
                              0)
                          .text
                          .make(),
                      UiSpacer.horizontalSpace(space: 10),
                      LinearProgressIndicator(
                        value:
                            controller.classificationUser?.progressLevelUp ?? 0,
                        backgroundColor: Vx.gray200,
                        color: primaryColor,
                      ).expand(),
                      UiSpacer.horizontalSpace(space: 10),
                      (controller.classificationUser?.nextLevel?.passingGrade
                                  .toString() ??
                              'Maks')
                          .text
                          .make()
                    ]),
                    'Selesaikan ${(controller.classificationUser?.consultationLeftToLevelUp)}x konsultasi untuk naik kelas ${controller.classificationUser?.nextLevel?.name ?? '-'}.'
                        .text
                        .sm
                        .make()
                        .px(16),
                  ]).p12().card.make(),
                  VStack([
                    'Pendapatan'.text.lg.semiBold.make(),
                    UiSpacer.verticalSpace(space: 10),
                    HStack([
                      'Total Saldo : '.text.make(),
                      UiSpacer.horizontalSpace(space: 10),
                      (controller.userData.value.balance?.toCurrency() ??
                              'Rp 0')
                          .text
                          .make()
                    ])
                  ]).p12().card.make().wFull(context),
                  HStack(
                    [
                      ElevatedButton(
                        onPressed: controller.openConsulting,
                        child: 'Riwayat Konsultasi'.text.make(),
                      ),
                      ElevatedButton(
                        onPressed: controller.openWithdraw,
                        child: 'Penarikan Dana'.text.make(),
                      ),
                    ],
                    alignment: MainAxisAlignment.spaceBetween,
                    axisSize: MainAxisSize.max,
                  ).p4(),
                  Form(
                    key: controller.formKey,
                    child: VStack([
                      HStack([
                        'Atur Jam Kerja'.text.semiBold.make().expand(),
                        'Tambah'
                            .text
                            .white
                            .makeCentered()
                            .continuousRectangle(
                              height: 30,
                              width: 100,
                              backgroundColor: primaryColor,
                            )
                            .onTap(controller.addSchedule),
                      ]),
                      UiSpacer.verticalSpace(space: 10),
                      controller.schedules == null ||
                              controller.schedules!.isEmpty
                          ? 'Jadwal Konsultasi Belum Tersedia'
                              .text
                              .makeCentered()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.schedules?.length ?? 0,
                              itemBuilder: (context, index) {
                                final schedule = controller.schedules![index];
                                return WorkTimeSchedule(
                                  schedule: schedule,
                                  delete: () =>
                                      controller.removeSchedule(schedule),
                                  onChangedDay: (day) =>
                                      controller.selectedDay(schedule, day),
                                  onTap: () => controller.selectWorkTime(
                                      schedule.startTime, schedule.endTime),
                                );
                              },
                            ),
                      UiSpacer.verticalSpace(space: 10),
                      ElevatedButton(
                              onPressed: controller.setupWorkTime,
                              child: 'Simpan'.text.make())
                          .objectCenterRight(),
                    ]).p12().card.make(),
                  ),
                ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
