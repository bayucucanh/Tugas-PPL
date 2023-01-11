import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/academy_partner/controller/apply_partner.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ApplyPartner extends GetView<ApplyPartnerController> {
  static const routeName = '/apply/partner';
  const ApplyPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ApplyPartnerController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Daftar Menjadi ${F.title} Partner'.text.sm.ellipsis.make(),
      body: Form(
        key: controller.formKey,
        child: VStack(
          [
            Image.asset(redLogoPath).w(50).centered(),
            UiSpacer.verticalSpace(),
            '${F.title} Partner merupakan Pelatih Ahli yang bisa membuat Video Pembelajaran untuk pemain dan menjadi seorang Konsultan dengan merespon pertanyaan Pemain.'
                .text
                .sm
                .make()
                .p8()
                .card
                .make(),
            UiSpacer.verticalSpace(),
            VStack([
              'Keuntungan : '.text.semiBold.sm.make(),
              HStack([
                const Icon(
                  FontAwesomeIcons.check,
                  size: 14,
                  color: primaryColor,
                ),
                UiSpacer.horizontalSpace(space: 5),
                'Mendapatkan penghasilan dari user yang melakukan konsultasi'
                    .text
                    .sm
                    .make()
                    .expand(),
              ]),
              HStack([
                const Icon(
                  FontAwesomeIcons.check,
                  size: 14,
                  color: primaryColor,
                ),
                UiSpacer.horizontalSpace(space: 5),
                'Menerima royalti dari setiap subscriber dengan memberikan video pembelajaran premium'
                    .text
                    .sm
                    .make()
                    .expand(),
              ]),
            ]).p8().card.make(),
            UiSpacer.verticalSpace(),
            'Silahkan ajukan diri untuk bisa menjadi bagian dari ${F.title}!'
                .text
                .sm
                .center
                .makeCentered(),
            TextFormField(
              controller: controller.licenseTx,
              decoration: InputDecoration(
                hintText: 'Lisensi Kepelatihan',
                labelText: 'Lisensi Kepelatihan',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.file_upload_rounded),
                  onPressed: controller.pickLicense,
                ),
              ),
              readOnly: true,
              showCursor: false,
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              controller: controller.certificateTx,
              decoration: InputDecoration(
                hintText: 'Sertifikat Konsultan',
                labelText: 'Sertifikat Konsultan',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.file_upload_rounded),
                  onPressed: controller.pickCertificate,
                ),
              ),
              readOnly: true,
              showCursor: false,
            ),
            UiSpacer.verticalSpace(),
            FormField(
              validator: (value) {
                if (controller.agreement == false) {
                  return 'Harus dicentang';
                }
                return null;
              },
              builder: (field) => Obx(
                () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: primaryColor,
                  value: controller.agreement,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onChanged: controller.toggleAgreement,
                  title:
                      'Dengan ini saya menyatakan data yang saya berikan adalah benar dan akan mematuhi segala aturan ${F.title}'
                          .text
                          .sm
                          .make(),
                  subtitle: !controller.agreement
                      ? 'Harus dicentang'.text.color(Colors.red).sm.make()
                      : null,
                ),
              ),
            ),
            UiSpacer.verticalSpace(space: 40),
            Obx(() {
              if (controller.partnerStatus == null) {
                if (controller.isUploading == true) {
                  return const CircularProgressIndicator(
                    backgroundColor: primaryColor,
                    color: Colors.white,
                  ).centered();
                }
                return 'Ajukan ${F.title} Partner'
                    .text
                    .white
                    .makeCentered()
                    .continuousRectangle(
                      height: 40,
                      backgroundColor: Colors.green,
                    )
                    .onTap(controller.applyPartner);
              } else {
                if (controller.partnerStatus?.status?.id == 0) {
                  return 'Masih menunggu untuk Verifikasi'
                      .text
                      .white
                      .makeCentered()
                      .continuousRectangle(
                        height: 40,
                        backgroundColor: Vx.gray500,
                      );
                }

                if (controller.partnerStatus?.status?.id == 1) {
                  return 'Telah Terverifikasi'
                      .text
                      .white
                      .makeCentered()
                      .continuousRectangle(
                        height: 40,
                        backgroundColor: Vx.green500,
                      );
                }

                return VStack([
                  'Pengajuan Dibatalkan : ${controller.partnerStatus?.reason ?? 'Tidak ada alasan'}'
                      .text
                      .white
                      .make()
                      .box
                      .red500
                      .p8
                      .roundedSM
                      .makeCentered(),
                  UiSpacer.verticalSpace(),
                  'Ajukan ${F.title} Partner'
                      .text
                      .white
                      .makeCentered()
                      .continuousRectangle(
                        height: 40,
                        backgroundColor: Colors.green,
                      )
                      .onTap(controller.applyPartner)
                ]);
              }
            }),
          ],
          alignment: MainAxisAlignment.center,
          axisSize: MainAxisSize.max,
        ).p12().scrollVertical(),
      ),
    );
  }
}
