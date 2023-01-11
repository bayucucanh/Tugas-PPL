import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/learning_task.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/task_detail.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pod_player/pod_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';

class TaskDetailController extends BaseController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final TaskRequest _taskRequest = TaskRequest();
  final isLoadingVideo = false.obs;
  final loadingComments = false.obs;
  final message = TextEditingController();
  final isSendingMessage = false.obs;
  PodPlayerController? podPlayerController;
  final commentScroller = ScrollController();
  final taskDetail = TaskDetail().obs;
  final taskComments = Resource<List<Message>>(
    data: [],
    meta: Meta(total: 0),
  ).obs;
  final currentPage = 1.obs;
  final enableUpload = false.obs;
  final youtubeLink = TextEditingController();
  final youtubeLinkText = ''.obs;
  final isUploading = false.obs;
  final isYoutubeLink = true.obs;
  final toggleSelecteds = [
    true,
    false,
  ].obs;
  final ImagePicker _picker = ImagePicker();
  final video = FileObservable().obs;

  TaskDetailController() {
    taskDetail(TaskDetail(id: LearningTask.fromJson(Get.arguments).id));
  }

  @override
  void onInit() {
    getUserData();
    _fetchDetailTask();
    checkUpload();
    youtubeLink.addListener(() {
      youtubeLinkText(youtubeLink.text);
    });
    debounce(youtubeLinkText, (callback) => checkUpload());
    super.onInit();
  }

  changeUploadType(int? value) {
    for (int i = 0; i < toggleSelecteds.length; i++) {
      toggleSelecteds[i] = i == value;
    }
    isYoutubeLink(value == 0 ? true : false);
    if (value == 1) {
      youtubeLink.clear();
      youtubeLinkText('');
    } else {
      video(FileObservable());
    }
    toggleSelecteds.refresh();
    checkUpload();
  }

  selectFile({required ImageSource source}) async {
    XFile? file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(hours: 1));

    if (file != null) {
      video(FileObservable.xFileResult(file));
      checkUpload();
    }
  }

  _fetchDetailTask() async {
    try {
      EasyLoading.show();
      taskDetail(await _taskRequest.getTaskDetail(taskDetail.value.id!));
      EasyLoading.dismiss();
      setupVideo();
      fetchComments();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  refreshComments() async {
    try {
      currentPage(1);
      taskComments.value.data?.clear();
      fetchComments();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  fetchComments() async {
    loadingComments(true);
    var resp = await _taskRequest.getTaskMessage(taskDetail.value.id!,
        page: currentPage.value);
    taskComments.update((e) {
      e?.data?.addAll(resp.data!.map((e) => e));
      e?.meta = resp.meta;
    });
    loadingComments(false);
  }

  loadMoreComments() async {
    try {
      if (currentPage.value >= taskComments.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        currentPage.value += 1;
        fetchComments();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  postComment() async {
    try {
      isSendingMessage(true);
      await _taskRequest.postTaskMessage(taskDetail.value.id!, message.text);
      isSendingMessage(false);
      refreshController.requestRefresh();
      message.clear();
    } catch (e) {
      isSendingMessage(false);
      getSnackbar('Pemberitahuan', e.toString());
    }
  }

  void setupVideo() async {
    try {
      isLoadingVideo(true);

      podPlayerController = PodPlayerController(
        playVideoFrom: sourceVideo,
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          wakelockEnabled: true,
          isLooping: false,
        ),
      );
      await podPlayerController?.initialise();

      isLoadingVideo(false);
    } catch (e) {
      getSnackbar('', e.toString());
      isLoadingVideo(false);
    }
  }

  confirmUploadVideo() {
    Get.defaultDialog(
      title: 'Upload File',
      content: const VStack([
        Text('Apakah benar anda akan mengupload video ini?'),
      ]),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: const Text(
            'Batal',
            style: TextStyle(
              color: primaryColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: uploadingFile,
          child: const Text('Kirim'),
        ),
      ],
    );
  }

  uploadingFile() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      isUploading(true);
      await _taskRequest.uploadVideo(
        learningId: taskDetail.value.learningId!,
        videoUrl: youtubeLink.text,
        videoFile: video.value,
      );
      _fetchDetailTask();
    } catch (_) {
      isUploading(false);
      getSnackbar('Informasi', 'Gagal mengupload file video.');
    }
  }

  shareTask() async {
    try {
      EasyLoading.show();
      final box = Get.context?.findRenderObject() as RenderBox?;
      String message =
          'Nama saya adalah ${userData.value.player?.name ?? '-'}, saya sudah mengikuti pelatihan kelas Coach ${taskDetail.value.creatorName ?? '-'} di aplikasi ${F.title}. Berikut video kelas yang sudah saya selesaikan : \n ${taskDetail.value.video?.url ?? '-'}';
      await Share.share(
        message,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  PlayVideoFrom get sourceVideo {
    VideoPlayerOptions options = VideoPlayerOptions(
      allowBackgroundPlayback: false,
      mixWithOthers: false,
    );
    if (taskDetail.value.video?.isLocalProvider == true) {
      final token = Storage.get(ProfileStorage.token);
      return PlayVideoFrom.network(taskDetail.value.video!.url!,
          httpHeaders: {
            'Authorization': token,
          },
          videoPlayerOptions: options);
    } else {
      return PlayVideoFrom.youtube(taskDetail.value.video!.url!,
          videoPlayerOptions: options);
    }
  }

  checkUpload() {
    if (isYoutubeLink.value) {
      if (youtubeLink.text.isNotEmpty) {
        enableUpload(true);
      } else {
        enableUpload(false);
      }
    } else {
      if (video.value.path != null) {
        enableUpload(true);
      } else {
        enableUpload(false);
      }
    }
  }
}
