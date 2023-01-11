import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/reusable/bottomsheet_component.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/verify_test_params.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class FormVerificationBottomsheet extends StatelessWidget {
  final VerifyTestParamsController vm;
  const FormVerificationBottomsheet({Key? key, required this.vm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetComponent(
      child: VStack([
        'Form Verifikasi'.text.semiBold.xl.make(),
        TextFormField(
          controller: vm.reason,
          decoration: const InputDecoration(
            hintText: 'Alasan/Komentar',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor,
              ),
            ),
          ),
          maxLines: 5,
          minLines: 5,
          cursorColor: primaryColor,
          style: const TextStyle(fontSize: 12),
        ),
        UiSpacer.verticalSpace(),
        HStack(
          [
            'Tolak'
                .text
                .color(primaryColor)
                .makeCentered()
                .continuousRectangle(
                    width: 150,
                    height: 40,
                    backgroundColor: Colors.white,
                    borderSide: const BorderSide(color: primaryColor))
                .onInkTap(vm.deniedDialog),
            'Verifikasi'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  width: 150,
                  height: 40,
                  backgroundColor: primaryColor,
                )
                .onInkTap(vm.acceptDialog),
          ],
          alignment: MainAxisAlignment.spaceEvenly,
          axisSize: MainAxisSize.max,
        ),
      ]).safeArea(),
    );
  }
}
