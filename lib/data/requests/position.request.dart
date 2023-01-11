import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class PositionRequest extends NetworkBase {
  Future<Resource<List<PlayerPosition>>> getPlayerPositions({
    int? page = 1,
    String? option = 'select',
  }) async {
    var response = await network.get('/position/player', queryParameters: {
      'option': option,
      'orderBy': 'asc',
      'page': page,
    });

    return Resource(
      data: (response?.data['data'])
          .map<PlayerPosition>((data) => PlayerPosition.fromJson(data))
          .toList(),
    );
  }

  Future<Resource<List<CoachPosition>>> getCoachPositions({
    int? page = 1,
  }) async {
    var response = await network.get('/position/coach', queryParameters: {
      'option': 'select',
      'orderBy': 'asc',
      'page': 1,
    });

    return Resource(
      data: (response?.data['data'])
          .map<CoachPosition>((data) => CoachPosition.fromJson(data))
          .toList(),
    );
  }
}
