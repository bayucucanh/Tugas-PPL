import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/add_promo.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_selection_form/new_selection_form.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/new_student_form.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/promo_types/promo_type_screen.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/target_promo/target_promo.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPromo extends GetView<AddPromoController> {
  static const routeName = '/transfermarket/new-promo';
  const AddPromo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddPromoController());
    return WillPopScope(
      onWillPop: controller.exitPromo,
      child: DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: Obx(() => controller.title.value.text.make()),
        resizeToAvoidBottomInset: false,
        leading: GestureDetector(
          onTap: controller.backPage,
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
              onPressed: controller.cancelDialog,
              tooltip: 'Batal',
              icon: const Icon(Icons.delete_forever_rounded)),
        ],
        body: Obx(
          () => PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const TargetPromo(),
              const PromoTypeScreen(),
              controller.typePromo.selectedType?.id == 1
                  ? const NewStudentForm()
                  : const NewSelectionForm(),
            ],
          ),
        ),
      ),
    );
  }
}
