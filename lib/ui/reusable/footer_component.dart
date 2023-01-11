import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:get/get.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/constant/styles.dart';

class FooterComponent extends StatelessWidget {
  const FooterComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: Get.width,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('available_on'.tr,
                  style: GoogleFonts.poppins(textStyle: creditTextStyle)),
              SvgPicture.asset(creditIosIcon),
              Text(' IOS ',
                  style: GoogleFonts.poppins(textStyle: creditTextStyle)),
              SvgPicture.asset(creditAndroidIcon),
              Text(' Android',
                  style: GoogleFonts.poppins(textStyle: creditTextStyle))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'supported_by'.tr,
                style: GoogleFonts.poppins(textStyle: creditTextStyle),
              ),
              Image.asset(
                creditLogoIcon,
                color: creditColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
