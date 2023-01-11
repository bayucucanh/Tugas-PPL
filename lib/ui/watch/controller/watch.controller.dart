import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/video.request.dart';
import 'package:mobile_pssi/ui/watch/controller/upload_video.controller.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pod_player/pod_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WatchController extends BaseController {
  final refreshController = RefreshController();
  final isLoading = false.obs;
  final isLoadingVideo = false.obs;
  final currentWatch = 0.obs;
  Class classDetail = Class();
  final videos = <VideoModel>[].obs;
  final _classRequest = ClassRequest();
  final _videoRequest = VideoRequest();
  final videoDisabled = false.obs;
  PodPlayerController? podPlayerController;
  UploadVideoController uploadVideo = Get.put(UploadVideoController());

  WatchController() {
    classDetail = Class.fromJson(Get.arguments);
  }

  @override
  void onInit() {
    _fetchDetails();
    super.onInit();
  }

  @override
  void onClose() {
    podPlayerController?.dispose();
    super.onClose();
  }

  logViewVideo() async {
    try {
      bool logged = await _videoRequest.logVideo(id: currentVideo!.id!);
      if (logged == false) {
        if (podPlayerController?.isVideoPlaying == true) {
          podPlayerController?.pause();
          podPlayerController?.videoState == PodVideoState.error;
        }
      }
    } catch (e) {
      if (podPlayerController?.isVideoPlaying == true) {
        podPlayerController?.pause();
        podPlayerController?.videoSeekTo(const Duration(seconds: 0));
        videoDisabled(true);
      }
      getSnackbar('Informasi', e.toString());
    }
  }

  refreshData() {
    try {
      _fetchDetails();
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetails() async {
    try {
      EasyLoading.show();
      Class value = await _classRequest.getDetail(id: classDetail.id!);
      classDetail = value;
      videos(value.playerVideo);
      if (currentVideo != null) {
        setupVideo();
      } else {
        getSnackbar('Informasi', 'Video kelas belum tersedia.');
      }
      EasyLoading.dismiss();
    } catch (e) {
      getSnackbar('Informasi', e.toString());
      EasyLoading.dismiss();
    }
  }

  changeVideo(int index) async {
    try {
      isLoadingVideo(true);
      videoDisabled(false);

      if (podPlayerController?.isVideoPlaying == true) {
        podPlayerController?.pause();
      }

      currentWatch(index);

      podPlayerController?.changeVideo(
          playVideoFrom: await videoSource, playerConfig: playerConfig);

      isLoadingVideo(false);
    } catch (e) {
      videoDisabled(true);
      podPlayerController = null;
      isLoadingVideo(false);
      getSnackbar('Informasi', e.toString());
    }
  }

  void setupVideo() async {
    try {
      isLoadingVideo(true);
      videoDisabled(false);

      if (videos.isNotEmpty) {
        await _videoRequest.videoAvailability(
            id: videos[currentWatch.value].id!);
      }

      bool checkUploadingData = false;
      bool logVideo = false;

      podPlayerController = PodPlayerController(
        playVideoFrom: await videoSource,
        podPlayerConfig: playerConfig,
      )..addListener(
          () => videoListener(
            isUploadingData: checkUploadingData,
            logVideo: logVideo,
          ),
        );

      await podPlayerController?.initialise();

      isLoadingVideo(false);
    } catch (e) {
      videoDisabled(true);
      podPlayerController = null;
      getSnackbar('Informasi', e.toString());
      isLoadingVideo(false);
    }
  }

  videoListener({bool? isUploadingData, bool? logVideo}) {
    final bool? isPlaying = podPlayerController?.isVideoPlaying;
    final Duration? duration = podPlayerController?.currentVideoPosition;
    final Duration? totalVideoDuration = podPlayerController?.totalVideoLength;
    final Duration checkBeforeDuration =
        Duration(seconds: (totalVideoDuration!.inSeconds - 10));
    if (isPlaying == true) {
      if (duration!.inSeconds.isEqual(1)) {
        logViewVideo();
      }

      if (checkBeforeDuration.compareTo(duration) == -1) {
        if (currentVideo?.checkedVideo == false && isUploadingData == false) {
          checkVideo(true, currentVideo);
          isUploadingData = true;
        }
      }
    }
  }

  checkVideo(bool? value, VideoModel? video) async {
    try {
      EasyLoading.show();
      await _videoRequest.doneWatching(id: video!.id!);
      _fetchDetails();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  VideoModel? get currentVideo {
    if (videos.isNotEmpty) {
      return videos[currentWatch.value];
    }
    return null;
  }

  Future<PlayVideoFrom> get videoSource async {
    if (videos[currentWatch.value].video?.isLocalProvider == true) {
      final token = Storage.get(ProfileStorage.token);
      return PlayVideoFrom.network(
        videos[currentWatch.value].video!.url!,
        httpHeaders: {
          'Authorization': 'Bearer $token',
          'Connection': 'keep-alive',
        },
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );
    } else {
      final urls = await PodPlayerController.getYoutubeUrls(
          videos[currentWatch.value].video!.url!);
      return PlayVideoFrom.networkQualityUrls(
        videoUrls: urls!,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );
    }
  }

  PodPlayerConfig get playerConfig => const PodPlayerConfig(
        autoPlay: false,
        wakelockEnabled: true,
        isLooping: false,
      );
}
