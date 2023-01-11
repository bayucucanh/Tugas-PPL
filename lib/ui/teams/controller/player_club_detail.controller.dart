import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/verify_task/learning_task.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/data/requests/player.request.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/ui/scouting/parts/open_video.dart';

class PlayerClubDetailController extends BaseController {
  final _playerRequest = PlayerRequest();
  final _taskRequest = TaskRequest();
  final _player = const Player().obs;
  final canSavePlayer = false.obs;
  final tasks = Resource<List<VerifyTask>>(data: []).obs;
  final pageTask = 1.obs;

  PlayerClubDetailController() {
    _player(Player.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchPlayer();
    _fetchTasks();
    super.onInit();
  }

  _fetchTasks() async {
    try {
      EasyLoading.show();
      var resp = await _taskRequest.getSubmittedTaskList(
          page: pageTask.value, playerId: _player.value.id);
      tasks.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  _fetchPlayer() async {
    try {
      EasyLoading.show();
      _player(
          await _playerRequest.getScoutingPlayer(playerId: _player.value.id));
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  openVideo(LearningTask? learningTask) {
    Get.dialog(OpenVideo(
      learningTask: learningTask,
    ));
  }

  Player? get player => _player.value;
}
