import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/ui/reusable/bottomsheet_component.dart';
import 'package:velocity_x/velocity_x.dart';

class CityBottomSheet extends StatelessWidget {
  final PersonalDataController controller;
  const CityBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
      child: VStack([
        'Pilih Kota'.text.semiBold.xl.make(),
        Obx(
          () => controller.loadCity.value
              ? const CircularProgressIndicator().centered()
              : controller.cities.value.data!.isEmpty
                  ? 'Tidak ada data kota'.text.make()
                  : ListView.builder(
                      itemCount: controller.cities.value.data?.length,
                      itemBuilder: (context, index) => ListTile(
                        title:
                            (controller.cities.value.data?[index].name ?? '-')
                                .text
                                .make(),
                        onTap: () => Get.back(
                            result: controller.cities.value.data?[index]),
                      ),
                      shrinkWrap: true,
                    ).h(600),
        )
      ]),
    );
  }
}
