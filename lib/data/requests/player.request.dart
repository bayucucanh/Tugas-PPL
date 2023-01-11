import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class PlayerRequest extends NetworkBase {
  Future<Resource<List<Player>>> getPlayers({
    int? page = 1,
    int? positionId,
    int? cityId,
    String? height,
    String? weight,
    String? search,
  }) async {
    var resp = await network.get('/scouting/player', queryParameters: {
      'page': page,
      'position_id': positionId,
      'search': search,
      'height': height,
      'weight': weight,
      'city_id': cityId,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Player>((data) => Player.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Player> getScoutingPlayer({
    required int? playerId,
  }) async {
    var response = await network.get('/scouting/player/detail/$playerId');

    return Player.fromJson(response?.data['data']);
  }

  Future<Player> getPlayerById({
    required int? playerId,
  }) async {
    var response = await network.get('/player/detail/$playerId');

    return Player.fromJson(response?.data['data']);
  }

  Future<void> updatePosition({
    required int playerId,
    required int positionId,
  }) async {
    await network.patch('/player/$playerId/position', body: {
      'position_id': positionId,
    });
  }
}
