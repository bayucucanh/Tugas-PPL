import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/coach.card.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/scouting/controller/offer_form_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferFormCoach extends GetView<OfferFormCoachController> {
  static const routeName = '/coach/offer/form';
  const OfferFormCoach({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OfferFormCoachController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Penawaran'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        TextButton(onPressed: controller.offer, child: 'Tawarkan'.text.make()),
      ],
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: VStack([
            CoachCard(coach: controller.coach.value),
            UiSpacer.verticalSpace(),
            MultiSelectDialogField(
              onConfirm: controller.selectPositions,
              validator: (values) {
                if (values.isBlank == true) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              title: const Text('Pilih Posisi Pemain'),
              listType: MultiSelectListType.CHIP,
              selectedColor: primaryColor,
              searchable: true,
              selectedItemsTextStyle: const TextStyle(
                color: Colors.white,
              ),
              items: controller.positions.value.data!
                  .map((e) => MultiSelectItem(e, e.name ?? '-'))
                  .toList(),
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              controller: controller.offerText,
              validator: (value) {
                if (value.isBlank == true) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: 'Isi Penawaran', labelText: 'Isi Penawaran'),
              minLines: 5,
              maxLines: 5,
            ),
            UiSpacer.verticalSpace(),
            if (controller.file.value.path != null)
              Thumbnail(
                mimeType: 'application/pdf',
                widgetSize: 150,
                decoration: WidgetDecoration(
                  backgroundColor: Colors.blueAccent,
                  iconColor: Colors.red,
                ),
                dataResolver: () => controller.file.value.asUint8List,
              ).centered(),
            UiSpacer.verticalSpace(space: 10),
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: primaryColor,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: (controller.file.value.path == null
                      ? 'Pilih File'
                      : 'Ubah File')),
              validator: (value) {
                if (controller.file.value.path == null) {
                  return 'File tidak boleh kosong';
                }
                return null;
              },
              onTap: controller.selectFile,
              readOnly: true,
            ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
