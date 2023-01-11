import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  const PlayerCard({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZStack(
      [
        SvgPicture.asset(
          'assets/images/soccer-svgrepo-com.svg',
          color: const Color.fromARGB(30, 255, 255, 255),
        ).wh(180, 180).positioned(right: 0),
        HStack(
          [
            VStack(
              [
                CachedNetworkImage(
                  imageUrl:
                      player.photo == null ? player.gravatar() : player.photo!,
                  fit: BoxFit.cover,
                ).cornerRadius(80).wh(100, 100),
                UiSpacer.verticalSpace(space: 10),
                'ID : ${player.id ?? '-'}'.text.white.sm.make(),
                (player.clubPlayer?.club?.name ?? 'Tanpa Klub')
                    .text
                    .white
                    .sm
                    .ellipsis
                    .make(),
                if (player.website.isNotEmptyAndNotNull)
                  VStack(
                    [
                      UiSpacer.verticalSpace(space: 5),
                      HStack(
                        [
                          const Icon(
                            Icons.link_rounded,
                            color: primaryColor,
                          ),
                          'Kunjungi Website'.text.color(primaryColor).sm.make(),
                        ],
                        alignment: MainAxisAlignment.center,
                        crossAlignment: CrossAxisAlignment.center,
                      )
                          .continuousRectangle(
                            height: 30,
                            width: 140,
                            backgroundColor: Colors.white,
                          )
                          .onTap(player.openWebsite),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
            UiSpacer.horizontalSpace(space: 15),
            VStack([
              (player.name ?? '-').text.white.ellipsis.lg.semiBold.make(),
              UiSpacer.verticalSpace(space: 5),
              ('Jenis Kelamin : ${player.gender?.name ?? '-'}')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              ('Umur : ${player.age ?? '-'}').text.white.sm.ellipsis.make(),
              UiSpacer.verticalSpace(space: 5),
              ('Posisi : ${player.position?.name ?? '-'}')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              'Kewarganegaraan'.text.white.sm.make(),
              (player.nationality?.name ?? '-')
                  .text
                  .white
                  .sm
                  .ellipsis
                  .semiBold
                  .make(),
              UiSpacer.verticalSpace(space: 5),
              'Kaki Dominan'.text.white.sm.make(),
              (player.dominantFoot?.name ?? '-').text.white.sm.make(),
              UiSpacer.verticalSpace(space: 5),
              UiSpacer.verticalSpace(space: 5),
            ]).expand(),
          ],
          crossAlignment: CrossAxisAlignment.start,
          axisSize: MainAxisSize.max,
        ),
      ],
    ).p8().backgroundColor(primaryColor).cornerRadius(10);
  }
}
