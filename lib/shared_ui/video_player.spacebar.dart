import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoPlayerSpaceBar extends StatelessWidget {
  final PodPlayerController? playerController;
  final bool? loadVideo;
  final bool? disableVideo;
  const VideoPlayerSpaceBar({
    Key? key,
    this.playerController,
    this.loadVideo,
    this.disableVideo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return disableVideo == false
        ? playerController == null
            ? loadVideo == true
                ? const CircularProgressIndicator()
                    .centered()
                    .wh(50, 50)
                    .box
                    .black
                    .make()
                : 'Tidak ada video tersedia'
                    .text
                    .white
                    .makeCentered()
                    .box
                    .black
                    .make()
            : PodVideoPlayer(
                controller: playerController!,
                alwaysShowProgressBar: true,
                backgroundColor: Colors.black,
                onVideoError: () => 'Tidak dapat memulai video'.text.make(),
              )
        : 'Tidak ada video tersedia'.text.white.makeCentered().box.black.make();
  }
}
