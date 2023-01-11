import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/extensions/format_date.extension.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/academy_partner/controller/view_partner.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewPartner extends GetView<ViewPartnerController> {
  static const routeName = '/partners/view';
  const ViewPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ViewPartnerController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Informasi Partner'.text.make(),
        body: VStack([
          VStack([
            'Informasi Partner'.text.semiBold.xl.make(),
            UiSpacer.verticalSpace(),
            'Nama : ${controller.partner?.employee?.name ?? '-'}'.text.make(),
            UiSpacer.verticalSpace(space: 10),
            'Disubmit pada : ${controller.partner?.createdAt?.toFormattedDate() ?? '-'}'
                .text
                .make(),
            UiSpacer.verticalSpace(space: 10),
            'Perubahan Terakhir : ${controller.partner?.updatedFormat ?? '-'}'
                .text
                .make(),
            UiSpacer.verticalSpace(space: 10),
            HStack([
              'Status : '.text.make(),
              (controller.partner?.status?.name ?? '-')
                  .text
                  .color(controller.partner?.status?.statusColor())
                  .make()
            ]),
          ]).p12().card.make().wFull(context),
          UiSpacer.verticalSpace(),
          'Dokumen Pendukung'.text.semiBold.make(),
          controller.partner!.employee!.user!.partnerDocuments!.isEmpty
              ? 'Belum ada dokumen pendukung di unggah'.text.make()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final feature = controller
                        .partner?.employee?.user?.partnerDocuments?[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      minLeadingWidth: 10,
                      leading: CircleAvatar(
                        backgroundColor: feature?.status?.statusColor(),
                      ).wh(20, 20),
                      title: (feature?.name ?? '-').text.make(),
                      subtitle: 'Lihat Detil'.text.make(),
                      onTap: () => controller.openDialog(feature),
                    );
                  },
                  itemCount: controller
                          .partner?.employee?.user?.partnerDocuments?.length ??
                      0,
                ),
          if (controller.partner?.status?.id == 1)
            VStack([
              HStack([
                'Fitur Partner'.text.semiBold.make().expand(),
                const Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message:
                      'Untuk mengaktifkan fitur geser atau tap toggle dibawah ke sebelah kanan, untuk menonaktifkan tap kembali atau geser ke sebelah kiri.',
                  showDuration: Duration(seconds: 5),
                  child: Icon(
                    Icons.help_outline_rounded,
                  ),
                ),
              ]),
              SwitchListTile.adaptive(
                title: 'Konsultasi'.text.make(),
                value: controller.activeConsultant,
                onChanged: controller.toggleConsultant,
              ),
              SwitchListTile.adaptive(
                title: 'Konten Kreator'.text.make(),
                value: controller.activeContentCreator,
                onChanged: controller.toggleContentCreator,
              ),
            ]),
          if (controller.partner?.status?.id == 0)
            VStack([
              TextFormField(
                controller: controller.reason,
                decoration: const InputDecoration(
                    hintText: 'Alasan Untuk Ditolak', labelText: 'Alasan'),
                minLines: 3,
                maxLines: 3,
              ),
              UiSpacer.verticalSpace(),
              HStack([
                ElevatedButton(
                    onPressed: () => controller.verifyDialog(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: 'Tolak'.text.color(primaryColor).make()),
                UiSpacer.horizontalSpace(),
                ElevatedButton(
                    onPressed: () => controller.verifyDialog(1),
                    child: 'Terima'.text.make()),
              ]).objectCenterRight(),
            ]),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
