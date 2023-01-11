import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/controller/test_parameter.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class TestParameter extends GetView<TestParameterController> {
  static const routeName = '/test/parameters';
  const TestParameter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TestParameterController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Performance Test'.text.make(),
      body: VStack([
        // const Icon(
        //   Icons.videocam_rounded,
        //   color: Colors.white,
        //   size: 48,
        // ).h(250).box.black.make().wFull(context),
        UiSpacer.verticalSpace(),
        Obx(
          () => VStack([
            'Tutorial Tes Parameter'.text.semiBold.xl.make(),
            VStack([
              'Deskripsi'.text.semiBold.make(),
              UiSpacer.verticalSpace(space: 10),
              'Tes parameter merupakan standar penilaian untuk pelatih guna mengetahui kondisi atlet.'
                  .text
                  .make(),
              UiSpacer.verticalSpace(space: 10),
              Linkify(
                text:
                    'Download panduan tes parameter melalui link https://prima-academy.co.id',
                onOpen: (link) => controller.openLink(link.url),
                options: const LinkifyOptions(
                  humanize: true,
                ),
                linkStyle: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 'Download panduan disini (pdf)'.text.italic.make(),
              // 'Download worksheet disini (pdf)'.text.italic.make(),
            ]).p12().card.make(),
            UiSpacer.verticalSpace(),
            CheckboxListTile(
              value: controller.confirmTest.value,
              onChanged: controller.changeConfirmation,
              title: 'Saya sudah memahami cara Tes Parameter'.text.sm.make(),
            ),
            UiSpacer.verticalSpace(),
            'Posisi Pemain'.text.semiBold.make(),
            DropdownButtonFormField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText:
                      controller.selectedPosition?.name ?? 'Belum dipilih',
                ),
                items: controller.positionItems
                    ?.map((e) => DropdownMenuItem(
                          value: e,
                          child: (e.name ?? '-').text.make(),
                        ))
                    .toList(),
                onChanged: controller.changePosition),
            UiSpacer.verticalSpace(),
            'Isi Hasil'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  backgroundColor: controller.confirmTest.value &&
                          controller.selectedPosition?.id != null
                      ? primaryColor
                      : Vx.gray400,
                )
                .onTap(controller.confirmTest.value &&
                        controller.selectedPosition?.id != null
                    ? controller.openTechniqueForm
                    : null),
          ]).p12(),
        ),
      ]).scrollVertical(),
    );
  }
}
