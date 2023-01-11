import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class ClubRequest extends NetworkBase {
  Future<Resource<List<Club>>> getClubs({int? limit, int? page = 1}) async {
    var resp = await network
        .get('/club/get', queryParameters: {'limit': limit, 'page': page});

    return Resource(
      data: (resp?.data['data'])
          .map<Club>((data) => Club.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<Class>>> getClass(
    int userCoachId, {
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    bool activeClass = false,
  }) async {
    List<Class> classList = [];

    var params = {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'active_class': activeClass,
    };

    var resp = await network.get('/coach/classes/$userCoachId',
        queryParameters: params);

    classList = resp?.data["data"]
        .map<Class>((dynamic item) => Class.fromJson(item))
        .toList();

    return Resource(
        data: classList,
        meta: Meta(
          total: resp?.data['meta']['total'],
          currentPage: resp?.data['meta']['current_page'],
          lastPage: resp?.data['meta']['last_page'],
        ));
  }

  Future<Club> getDetail({int? clubId}) async {
    var resp = await network.get('/club/detail/$clubId');

    return Club.fromJson(resp?.data['data']);
  }

  Future<void> removePlayer({int? clubPlayerId}) async {
    await network.delete('/club/players/$clubPlayerId/delete');
  }

  Future<void> removeCoach({int? clubCoachId}) async {
    await network.delete('/coach/club/$clubCoachId/delete');
  }
}
