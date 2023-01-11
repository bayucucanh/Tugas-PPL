import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pod_player/pod_player.dart';
import 'package:readmore/readmore.dart';
import 'package:velocity_x/velocity_x.dart';

class BottomCard extends StatefulWidget {
  final VideoModel video;
  const BottomCard({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  late PodPlayerController _podPlayerController;
  @override
  void initState() {
    super.initState();
    _podPlayerController = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
          wakelockEnabled: false,
        ),
        playVideoFrom: widget.video.video!.isLocalProvider
            ? PlayVideoFrom.network(widget.video.video!.url!, httpHeaders: {
                'Authorization': 'Bearer ${Storage.get(ProfileStorage.token)}',
              })
            : PlayVideoFrom.youtube(widget.video.video!.url!))
      ..initialise();
  }

  @override
  void dispose() {
    _podPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VStack([
      PodVideoPlayer(
              podProgressBarConfig: const PodProgressBarConfig(
                alwaysVisibleCircleHandler: true,
              ),
              controller: _podPlayerController)
          .h(200),
      UiSpacer.verticalSpace(),
      'Keahlian'.text.semiBold.make(),
      widget.video.videoSkills == null || widget.video.videoSkills!.isEmpty
          ? 'Tidak ada keahlian/keterampilan dipilih'.text.make()
          : widget.video.videoSkills!.join(', ').text.make(),
      UiSpacer.verticalSpace(space: 5),
      'Deskripsi'.text.semiBold.make(),
      UiSpacer.verticalSpace(space: 5),
      ReadMoreText(
        widget.video.description ?? 'Tidak ada deskripsi',
        trimMode: TrimMode.Length,
        colorClickableText: primaryColor,
        trimLength: 150,
        moreStyle: const TextStyle(
          color: primaryColor,
        ),
        lessStyle: const TextStyle(
          color: primaryColor,
        ),
        trimCollapsedText: 'Lihat semua',
        trimExpandedText: 'Lihat sedikit',
      ),
    ]).p12();
  }
}
