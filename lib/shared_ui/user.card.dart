import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class UserCard extends StatelessWidget {
  final User coach;
  const UserCard({
    Key? key,
    required this.coach,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZStack(
      [
        SvgPicture.asset(
          'assets/images/soccer-svgrepo-com.svg',
          color: const Color.fromARGB(55, 255, 255, 255),
        ).wh(150, 150).positioned(right: 0),
        HStack(
          [
            VStack(
              [
                CachedNetworkImage(
                  imageUrl: coach.employee?.photo == null
                      ? coach.gravatar()
                      : coach.employee!.photo!,
                  fit: BoxFit.cover,
                ).cornerRadius(80).wh(100, 100),
                UiSpacer.verticalSpace(space: 10),
                'ID : ${coach.employee?.id.toString().padLeft(6, '0') ?? '-'}'
                    .text
                    .white
                    .sm
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
            UiSpacer.horizontalSpace(space: 15),
            VStack([
              (coach.employee?.name ?? '-')
                  .text
                  .white
                  .ellipsis
                  .lg
                  .semiBold
                  .make(),
              if (coach.specialists!.isNotEmpty)
                VStack([
                  UiSpacer.verticalSpace(space: 10),
                  coach.specialists!
                      .map((e) => e.name)
                      .join(', ')
                      .text
                      .white
                      .semiBold
                      .sm
                      .ellipsis
                      .make(),
                ]),
              UiSpacer.verticalSpace(space: 10),
              (coach.employee?.clubCoach?.club == null
                      ? 'Belum ada klub'
                      : coach.employee?.clubCoach?.club?.name ?? '-')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              ('Jenis Kelamin : ${coach.employee?.gender?.name ?? '-'}')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              ('Umur : ${coach.employee?.age ?? '-'}')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
            ]).expand(),
          ],
          crossAlignment: CrossAxisAlignment.start,
          axisSize: MainAxisSize.max,
        ),
      ],
    ).p8().backgroundColor(primaryColor).cornerRadius(10);
  }
}
