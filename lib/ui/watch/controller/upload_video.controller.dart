import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/learning_task.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/ui/task_detail/task_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class UploadVideoController extends BaseController {
  final TaskRequest _taskRequest = TaskRequest();
  final isLoading = false.obs;
  final enableUpload = false.obs;
  final uploaded = false.obs;
  final youtubeLink = TextEditingController();
  final youtubeLinkText = ''.obs;
  final uploadedData = LearningTask().obs;
  final isYoutubeLink = true.obs;
  final toggleSelecteds = [
    true,
    false,
  ].obs;
  final ImagePicker _picker = ImagePicker();
  final video = FileObservable().obs;

  @override
  void onInit() {
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

  uploadFile(int learningId) async {
    try {
      isLoading(true);
      uploadedData(
        await _taskRequest.uploadVideo(
          learningId: learningId,
          videoUrl: youtubeLink.text,
          videoFile: video.value,
        ),
      );

      isLoading(false);
      uploaded(true);
    } catch (e) {
      uploaded(false);
      isLoading(false);
      getSnackbar('Informasi', e.toString());
    }
  }

  openDetailVideo(LearningTask? task) {
    Get.toNamed(TaskDetail.routeName, arguments: task?.toJson());
  }

  selectFile({required ImageSource source}) async {
    XFile? file = await _picker.pickVideo(
        source: source, maxDuration: const Duration(hours: 1));

    if (file != null) {
      video(FileObservable.xFileResult(file));
      checkUpload();
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
