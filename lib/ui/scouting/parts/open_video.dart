import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/verify_task/learning_task.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pod_player/pod_player.dart';
import 'package:velocity_x/velocity_x.dart';

class OpenVideo extends StatefulWidget {
  final LearningTask? learningTask;
  const OpenVideo({
    Key? key,
    required this.learningTask,
  }) : super(key: key);

  @override
  State<OpenVideo> createState() => _OpenVideoState();
}

class _OpenVideoState extends State<OpenVideo> {
  PodPlayerController? podPlayerController;
  bool? isLoading = false;

  PodPlayerConfig get _playerConfig => const PodPlayerConfig(
        autoPlay: false,
        wakelockEnabled: true,
        isLooping: false,
      );

  VideoPlayerOptions get _videoOptions => VideoPlayerOptions(
        allowBackgroundPlayback: false,
        mixWithOthers: false,
      );

  @override
  void initState() {
    _setupPodPlayer();
    super.initState();
  }

  _setupPodPlayer() async {
    isLoading = true;
    setState(() {});
    if (widget.learningTask?.isLocalProvider == false) {
      final urls =
          await PodPlayerController.getYoutubeUrls(widget.learningTask!.video!);
      podPlayerController = PodPlayerController(
          playVideoFrom: PlayVideoFrom.networkQualityUrls(
            videoUrls: urls!,
            videoPlayerOptions: _videoOptions,
          ),
          podPlayerConfig: _playerConfig);
    } else {
      final token = Storage.get(ProfileStorage.token);
      podPlayerController = PodPlayerController(
          playVideoFrom: PlayVideoFrom.network(widget.learningTask!.video!,
              videoPlayerOptions: _videoOptions,
              httpHeaders: {'Authorization': 'Bearer $token'}),
          podPlayerConfig: _playerConfig);
    }
    podPlayerController?.initialise();
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    podPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          podPlayerController == null
              ? isLoading == true
                  ? VStack([
                      const CircularProgressIndicator().centered(),
                      'Sedang inisialisasi video...'.text.makeCentered(),
                    ])
                  : 'Tidak dapat memulai video'.text.make()
              : PodVideoPlayer(
                  controller: podPlayerController!,
                  alwaysShowProgressBar: true,
                  backgroundColor: Colors.black,
                  onVideoError: () => 'Tidak dapat memulai video'.text.make(),
                ),
        ],
      ),
    );
  }
}
