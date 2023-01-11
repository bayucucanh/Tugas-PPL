import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/home/controller/employee.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AcademyPartnerButton extends GetView<EmployeeController> {
  const AcademyPartnerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        SvgPicture.asset(starPartnerImage),
        UiSpacer.horizontalSpace(),
        VStack(
          [
            '${F.title} Partner'.text.bold.make(),
            UiSpacer.verticalSpace(space: 10),
            'Bergabung menjadi Official Pelatih Ahli di Aplikasi ${F.title} untuk mengembangkan generasi Sepak Bola Indonesia.'
                .text
                .sm
                .light
                .make()
                .expand(),
            'Gabung'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  backgroundColor: primaryColor,
                )
                .onTap(controller.registerPartner)
          ],
          alignment: MainAxisAlignment.start,
        ).expand()
      ],
      alignment: MainAxisAlignment.start,
      crossAlignment: CrossAxisAlignment.start,
    ).h(130).p12().card.make().wFull(context).p12();
  }
}
