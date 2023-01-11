import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class JoinClassDialog extends StatelessWidget {
  final Function()? onYes;
  const JoinClassDialog({
    Key? key,
    this.onYes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack([
        Image.asset(
          loginHeader,
          height: 150,
        ).centered(),
        UiSpacer.verticalSpace(),
        'Apakah kamu ingin mengikuti kelas ini?'.text.semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        'Kelas ini akan ditambahkan ke menu "Kelasku" dan menjadi milik kamu. Ingin menambahkan kelas?'
            .text
            .medium
            .gray500
            .make(),
        UiSpacer.verticalSpace(space: 40),
        HStack(
          [
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Get.back(),
              child: 'Tidak'.text.make().px20().py4(),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onYes,
              child: 'Ya'.text.color(primaryColor).make().px20().py4(),
            ),
          ],
          axisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.end,
        ),
      ]).p20(),
    );
  }
}
