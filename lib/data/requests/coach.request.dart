import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';

class CoachRequest extends NetworkBase {
  Future<Resource<List<User>>> getCoachList({
    int? limit,
    String? option,
    int? page = 1,
    bool onlyPartner = false,
    bool sortByPartner = false,
  }) async {
    var resp = await network.get('/coach/list', queryParameters: {
      'limit': limit,
      'option': option,
      'page': page,
      'partner_only': onlyPartner,
      'sortByPartner': sortByPartner,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<User>((data) => User.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<User> getProfile({int? userId}) async {
    var resp = await network.get('/coach/profile/$userId');
    return User.fromJson(resp?.data['data']);
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
      'filter': 'has_video',
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
      ),
    );
  }

  Future<Resource<List<User>>> getCoachScout({
    int? limit,
    int? page = 1,
    String? search,
  }) async {
    var resp = await network.get('/coach/scout', queryParameters: {
      'limit': limit,
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<User>((data) => User.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<CoachTeam>>> getCoachTeams({
    int? limit,
    int? page = 1,
    String? search,
  }) async {
    var resp = await network.get('/coach/teams', queryParameters: {
      'limit': limit,
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<CoachTeam>((data) => CoachTeam.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> deleteClass({required int classId}) async {
    await network.delete('/classes/delete/$classId');
  }
}
