import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/performance_form.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class MentalFormField extends StatefulWidget {
  final int index;
  final PerformanceForm performanceForm;
  final Function()? rarely;
  final Function()? sometimes;
  final Function()? often;
  const MentalFormField({
    Key? key,
    required this.index,
    required this.performanceForm,
    required this.rarely,
    required this.sometimes,
    required this.often,
  }) : super(key: key);

  @override
  State<MentalFormField> createState() => _MentalFormFieldState();
}

class _MentalFormFieldState extends State<MentalFormField> {
  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        "${(widget.index + 1)}. ".text.semiBold.make(),
        UiSpacer.horizontalSpace(space: 2),
        (widget.performanceForm.scatQuestion?.question ?? '-')
            .text
            .semiBold
            .make()
            .expand(),
      ]),
      UiSpacer.verticalSpace(),
      HStack(
        [
          'Jarang'
              .text
              .color(widget.performanceForm.scatAnswer == 0
                  ? Colors.white
                  : Colors.black)
              .make()
              .box
              .color(widget.performanceForm.scatAnswer == 0
                  ? primaryColor
                  : Vx.gray200)
              .p8
              .roundedSM
              .make()
              .onTap(() {
            widget.rarely!();
            setState(() {});
          }),
          'Kadang'
              .text
              .color(widget.performanceForm.scatAnswer == 1
                  ? Colors.white
                  : Colors.black)
              .make()
              .box
              .color(widget.performanceForm.scatAnswer == 1
                  ? primaryColor
                  : Vx.gray200)
              .p8
              .roundedSM
              .make()
              .onTap(() {
            widget.sometimes!();
            setState(() {});
          }),
          'Sering'
              .text
              .color(widget.performanceForm.scatAnswer == 2
                  ? Colors.white
                  : Colors.black)
              .make()
              .box
              .color(widget.performanceForm.scatAnswer == 2
                  ? primaryColor
                  : Vx.gray200)
              .p8
              .roundedSM
              .make()
              .onTap(() {
            widget.often!();
            setState(() {});
          }),
        ],
        alignment: MainAxisAlignment.spaceEvenly,
        crossAlignment: CrossAxisAlignment.center,
        axisSize: MainAxisSize.max,
      ),
      TextFormField(
        showCursor: false,
        readOnly: true,
        validator: (value) {
          if (widget.performanceForm.scatAnswer == null) {
            return 'Harus diisi';
          }
          return null;
        },
      ).h(50),
    ]).py12();
  }
}
