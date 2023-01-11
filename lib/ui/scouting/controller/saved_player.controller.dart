import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/ui/scouting/player_scouting.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:mobile_pssi/utils/storage.dart';

class SavedPlayerController extends BaseController {
  final players = <Player>[].obs;

  @override
  void onInit() {
    _fetchPlayers();
    super.onInit();
  }

  _fetchPlayers() {
    if (Storage.hasData(ProfileStorage.savedPlayer)) {
      players.clear();
      List<dynamic> savedPlayers = Storage.get(ProfileStorage.savedPlayer);
      savedPlayers
          .map((savedPlayer) => players.add(Player.fromJson(savedPlayer)))
          .toList();
    }
  }

  deleteSavedPlayer(Player? player) {
    if (Storage.hasData(ProfileStorage.savedPlayer)) {
      List<dynamic> savedPlayers = Storage.get(ProfileStorage.savedPlayer);
      savedPlayers
          .removeWhere((savedPlayer) => savedPlayer['id'] == player?.id);

      _fetchPlayers();
    }
  }

  getDetail(Player? player) {
    Get.toNamed(ScoutingPlayerDetail.routeName, arguments: player?.toJson());
  }

  goScoutingPlayer() async {
    await Get.toNamed(PlayerScouting.routeName);
    _fetchPlayers();
  }
}
