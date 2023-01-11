import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/ui/reusable/bottomsheet_component.dart';
import 'package:velocity_x/velocity_x.dart';

class ProvinceBottomSheet extends StatelessWidget {
  final PersonalDataController controller;
  const ProvinceBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
      child: VStack([
        'Pilih Provinsi'.text.semiBold.xl.make(),
        Obx(() => controller.loadProvince.value
            ? const CircularProgressIndicator().centered()
            : controller.provinces.value.data!.isEmpty
                ? 'Tidak ada data provinsi'.text.make()
                : ListView.builder(
                    itemCount: controller.provinces.value.data?.length,
                    itemBuilder: (context, index) => ListTile(
                      title:
                          (controller.provinces.value.data?[index].name ?? '-')
                              .text
                              .make(),
                      onTap: () => Get.back(
                          result: controller.provinces.value.data?[index]),
                    ),
                    shrinkWrap: true,
                  ).h(600)),
      ]),
    );
  }
}
