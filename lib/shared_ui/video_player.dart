import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pod_player/pod_player.dart';

enum VideoSource {
  youtube,
  network,
}

class VideoPlayer extends StatefulWidget {
  final String? sourceUrl;
  final File? file;
  final bool isLocal;
  final VideoSource? videoSource;
  const VideoPlayer({
    Key? key,
    this.file,
    this.isLocal = false,
    this.videoSource,
    this.sourceUrl,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
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
        playVideoFrom: widget.isLocal == true && widget.videoSource == null
            ? PlayVideoFrom.file(widget.file)
            : widget.isLocal && widget.videoSource == VideoSource.network
                ? PlayVideoFrom.network(widget.sourceUrl!, httpHeaders: {
                    'Authorization':
                        'Bearer ${Storage.get(ProfileStorage.token)}',
                  })
                : PlayVideoFrom.youtube(widget.sourceUrl!))
      ..initialise();
  }

  @override
  void dispose() {
    _podPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      podProgressBarConfig: const PodProgressBarConfig(
        alwaysVisibleCircleHandler: true,
      ),
      controller: _podPlayerController,
    );
  }
}
