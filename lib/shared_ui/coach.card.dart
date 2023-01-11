import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachCard extends StatelessWidget {
  final Employee? coach;
  const CoachCard({
    Key? key,
    required this.coach,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZStack(
      [
        SvgPicture.asset(
          'assets/images/soccer-svgrepo-com.svg',
          color: const Color.fromARGB(83, 255, 255, 255),
        ).wh(150, 150).positioned(right: 0),
        HStack(
          [
            VStack(
              [
                CachedNetworkImage(
                  imageUrl:
                      coach?.photo == null ? coach!.gravatar() : coach!.photo!,
                  fit: BoxFit.cover,
                ).cornerRadius(80).wh(100, 100).badge(
                      color:
                          coach?.isOnline == true ? Colors.green : Colors.grey,
                    ),
                UiSpacer.verticalSpace(space: 10),
                'ID : ${coach?.id ?? '-'}'.text.white.sm.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
            UiSpacer.horizontalSpace(space: 15),
            VStack([
              (coach?.name ?? '-').text.white.ellipsis.lg.semiBold.make(),
              UiSpacer.verticalSpace(space: 10),
              (coach?.clubCoach == null
                      ? 'Belum ada klub'
                      : coach?.clubCoach?.club?.name ?? '-')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              ('Umur : ${coach?.age ?? '-'}').text.white.sm.ellipsis.make(),
            ]).expand(),
          ],
          crossAlignment: CrossAxisAlignment.start,
          axisSize: MainAxisSize.max,
        ),
      ],
    ).p8().backgroundColor(primaryColor).cornerRadius(10);
  }
}
