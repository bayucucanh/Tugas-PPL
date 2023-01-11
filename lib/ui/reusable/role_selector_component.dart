import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/constant/font.dart';
import 'package:mobile_pssi/ui/component/button_select_role_component.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class RoleSelectorComponent extends StatelessWidget {
  const RoleSelectorComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.8,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, right: 20),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.isBottomSheetOpen!
                  ? Navigator.of(context).pop()
                  : getSnackbar('Error', 'Could not close bottom sheet.'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Text(
            'LOGIN OPTIONS',
            style: TextStyle(
              color: Colors.white,
              fontSize: h2,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                ButtonSelectRoleComponent(
                  onTap: () => Get.offAllNamed('/dashboard_fpk_program'),
                  label: 'Login as FPK Program',
                ),
                ButtonSelectRoleComponent(
                  onTap: () => Get.offAllNamed('/dashboard_facilitator'),
                  label: 'Login as Facilitator',
                ),
                ButtonSelectRoleComponent(
                  onTap: () => Get.offAllNamed('/dashboard_committee'),
                  label: 'Login as Committee',
                ),
                ButtonSelectRoleComponent(
                  onTap: () => Get.offAllNamed('/dashboard_fpk_evaluation'),
                  label: 'Login as FPK Evaluation',
                ),
                // ButtonSelectRoleComponent(
                //   label: 'Login as Participants',
                //   onTap: () => Get.offAllNamed(DashboardParticipantScreen.routeName),
                // ),
                ButtonSelectRoleComponent(
                  label: 'Login as Tata Laksana',
                  onTap: () => Get.offAllNamed('/dashboard_tata_laksana'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
