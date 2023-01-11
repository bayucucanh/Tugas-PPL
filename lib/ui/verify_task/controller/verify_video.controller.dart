import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pod_player/pod_player.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyVideoController extends BaseController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final TaskRequest _taskRequest = TaskRequest();
  final isLoadingVideo = false.obs;
  final loadingComments = false.obs;
  final score = TextEditingController();
  final commentTx = TextEditingController();
  final message = TextEditingController();
  final isSendingMessage = false.obs;
  PodPlayerController? podPlayerController;
  final commentScroller = ScrollController();
  final taskDetail = VerifyTask().obs;
  final taskComments = Resource<List<Message>>(
    data: [],
    meta: Meta(total: 0),
  ).obs;
  final currentPage = 1.obs;

  VerifyVideoController() {
    taskDetail(VerifyTask.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    fetchDetailTask();
    super.onInit();
  }

  fetchDetailTask() async {
    var resp = await _taskRequest.getTaskVerifyDetail(taskDetail.value.id!);
    taskDetail(resp);
    setupVideo();
    fetchComments();
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

  refreshComments() async {
    try {
      currentPage(1);
      taskComments.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      fetchComments();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  fetchComments() async {
    try {
      loadingComments(true);
      var resp = await _taskRequest.getTaskMessage(
          taskDetail.value.learningTask!.id!,
          page: currentPage.value);
      taskComments.update((e) {
        e?.data?.addAll(resp.data!.map((e) => e));
        e?.meta = resp.meta;
      });
      loadingComments(false);
    } catch (e) {
      loadingComments(false);
      getSnackbar('Informasi', e.toString());
    }
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
      await _taskRequest.sendComment(
          taskDetail.value.learningTask!.id!, message.text);
      isSendingMessage(false);
      refreshController.requestRefresh();
      message.clear();
    } catch (e) {
      isSendingMessage(false);
      getSnackbar('Pemberitahuan', e.toString());
    }
  }

  acceptDialog() {
    Get.defaultDialog(
      title: "",
      content: VStack([
        const Text(
          'Apakah anda ingin menerima tugas pemain ini?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        UiSpacer.verticalSpace(),
        const Text(
          'Pemain yang dipilih akan diterima video nya. Ingin lanjut?',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
      ]),
      confirmTextColor: primaryColor,
      cancelTextColor: Colors.grey,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Tidak',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => acceptTask(),
          child: const Text(
            'Ya',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  deniedDialog() {
    Get.defaultDialog(
      title: "",
      content: VStack([
        const Text(
          'Apakah anda ingin menolak tugas pemain ini?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        UiSpacer.verticalSpace(),
        const Text(
          'Pemain yang dipilih akan ditolak dan pastikan untuk memberikan komentar yang membangun. Ingin lanjut?',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
      ]),
      confirmTextColor: primaryColor,
      cancelTextColor: Colors.grey,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Tidak',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => deniedTask(),
          child: const Text(
            'Ya',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  acceptTask() async {
    try {
      EasyLoading.show();
      await _taskRequest.acceptTask(
        taskDetail.value.id!,
        taskDetail.value.learningTask!.id!,
        reason: commentTx.text,
        score: score.text,
      );
      if (Get.isDialogOpen!) {
        Get.back();
      }
      commentTx.clear();
      fetchDetailTask();
      EasyLoading.dismiss();
    } catch (e) {
      getSnackbar('Informasi', e.toString());
      EasyLoading.dismiss();
    }
  }

  deniedTask() async {
    try {
      EasyLoading.show();
      await _taskRequest.deniedTask(
        taskDetail.value.id!,
        taskDetail.value.learningTask!.id!,
        reason: commentTx.text,
        score: score.text,
      );
      if (Get.isDialogOpen!) {
        Get.back();
      }
      commentTx.clear();
      fetchDetailTask();
      EasyLoading.dismiss();
    } catch (e) {
      getSnackbar('Informasi', e.toString());
      EasyLoading.dismiss();
    }
  }

  PlayVideoFrom get sourceVideo {
    VideoPlayerOptions options = VideoPlayerOptions(
      allowBackgroundPlayback: false,
      mixWithOthers: false,
    );

    if (taskDetail.value.learningTask?.isLocalProvider == true) {
      final token = Storage.get(ProfileStorage.token);
      return PlayVideoFrom.network(taskDetail.value.learningTask!.video!,
          httpHeaders: {
            'Authorization': token,
          },
          videoPlayerOptions: options);
    } else {
      return PlayVideoFrom.youtube(taskDetail.value.learningTask!.video!,
          videoPlayerOptions: options);
    }
  }
}
