import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/secure_document.dart';
import 'package:mobile_pssi/data/model/verify_task/learning_task.dart';
import 'package:mobile_pssi/data/model/verify_task/verify_task.dart';
import 'package:mobile_pssi/data/requests/document.request.dart';
import 'package:mobile_pssi/data/requests/player.request.dart';
import 'package:mobile_pssi/data/requests/task.request.dart';
import 'package:mobile_pssi/ui/scouting/offer_form_player.dart';
import 'package:mobile_pssi/ui/scouting/parts/open_video.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ScoutingPlayerDetailController extends BaseController {
  final refreshController = RefreshController();
  final _playerRequest = PlayerRequest();
  final _taskRequest = TaskRequest();
  final _documentRequest = DocumentRequest();
  final _player = const Player().obs;
  final tasks = Resource<List<VerifyTask>>(data: []).obs;
  final documents = Resource<List<SecureDocument>>(data: []).obs;
  final canSavePlayer = false.obs;
  final pageTask = 1.obs;

  ScoutingPlayerDetailController() {
    _player(Player.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _initialize();
    super.onInit();
  }

  _initialize() {
    _checkSavedPlayer();
    _fetchPlayer();
    _fetchTasks();
    _fetchDocuments();
  }

  refreshData() {
    try {
      _initialize();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
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

  _fetchTasks() async {
    try {
      EasyLoading.show();
      tasks(await _taskRequest.getSubmittedTaskList(
          page: pageTask.value, playerId: _player.value.id));
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  _fetchDocuments() async {
    try {
      EasyLoading.show();
      documents(await _documentRequest.getSecureDocuments(
          playerId: _player.value.id));
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  _checkSavedPlayer() {
    if (Storage.hasData(ProfileStorage.savedPlayer)) {
      List<dynamic> players = Storage.get(ProfileStorage.savedPlayer);
      dynamic found = players.firstWhere(
          (data) => data['id'] == _player.value.id,
          orElse: () => null);
      if (found != null) {
        canSavePlayer(false);
      } else {
        canSavePlayer(true);
      }
    } else {
      canSavePlayer(true);
    }
  }

  openOffer() {
    Get.toNamed(OfferFormPlayer.routeName, arguments: _player.value.toJson());
  }

  savePlayer() {
    if (Storage.hasData(ProfileStorage.savedPlayer)) {
      List<dynamic> players = Storage.get(ProfileStorage.savedPlayer);
      dynamic found = players.firstWhere(
          (data) => data['id'] == _player.value.id,
          orElse: () => null);
      if (found != null) {
        getSnackbar('Informasi', 'Pemain ini sudah pernah disimpan');
      } else {
        players.add(_player.value.toJson());
        Storage.save(ProfileStorage.savedPlayer, players);
        getSnackbar('Informasi', 'Pemain sudah disimpan');
      }
    } else {
      List<dynamic> players = [
        _player.value.toJson(),
      ];
      Storage.save(ProfileStorage.savedPlayer, players);
      getSnackbar('Informasi', 'Pemain sudah disimpan');
    }
    _checkSavedPlayer();
  }

  openVideo(LearningTask? learningTask) {
    Get.dialog(OpenVideo(
      learningTask: learningTask,
    ));
  }

  Player? get player => _player.value;
}
