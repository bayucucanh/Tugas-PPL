import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageTeam extends StatelessWidget {
  final Team? team;
  const ImageTeam({Key? key, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return team?.imageUrl == null
        ? Avatar(
            name: team?.name ?? '-',
            useCache: true,
          ).centered()
        : ImageCustom(
            url: team!.imageUrl!,
            blurhash: team?.blurhash,
            fit: BoxFit.cover,
          )
            .backgroundColor(Vx.gray500)
            .wh(100, 100)
            .cornerRadius(100)
            .centered();
  }
}
