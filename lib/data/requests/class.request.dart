import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/latest_watch.dart';
import 'package:mobile_pssi/data/model/log_video.dart';
import 'package:mobile_pssi/data/model/my_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class ClassRequest extends NetworkBase {
  Future<Resource<List<Class>>> getClass({
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    String? filter,
    int? classLevelId,
    int? classCategoryId,
    bool? onlyPremium, // use null to get all class
  }) async {
    List<Class> classList = [];
    var response = await network.get('/classes/get', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'filter': filter,
      'class_level_id': classLevelId,
      'class_category_id': classCategoryId,
      'premium_class_only': onlyPremium,
    });

    classList = response?.data["data"]
        .map<Class>((dynamic item) => Class.fromJson(item))
        .toList();

    return Resource(
      data: classList,
      meta: Meta(
        total: response?.data['meta']['total'],
        currentPage: response?.data['meta']['current_page'],
        lastPage: response?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<Class>>> getClassCreator({
    required int creatorId,
    String? search,
    int limit = 10,
    int page = 1,
    String? filter,
  }) async {
    var response =
        await network.get('/classes/$creatorId/creator', queryParameters: {
      'limit': limit,
      'search': search,
      'page': page,
      'filter': filter,
    });

    return Resource(
      data: (response?.data["data"] as List)
          .map<Class>((dynamic item) => Class.fromJson(item))
          .toList(),
      meta: Meta(
        total: response?.data['meta']['total'],
        currentPage: response?.data['meta']['current_page'],
        lastPage: response?.data['meta']['last_page'],
      ),
    );
  }

  Future<Class> getDetail({
    required int id,
  }) async {
    var response = await network.get('/classes/detail/$id');

    return Class.fromJson(response?.data['data']);
  }

  Future<bool> checkJoinedClass({required int id}) async {
    var response = await network.get('/classes/player/check/join/$id');
    return response?.data['join'];
  }

  Future<void> joinClass({required int id}) async {
    await network.post('/classes/player/join/$id');
  }

  Future<Resource<List<LatestWatch>>> latestWatchVideos() async {
    var resp = await network.get('/learning/player/latest-watch');
    return Resource(
      data: (resp?.data["data"] as List)
          .map<LatestWatch>((dynamic item) => LatestWatch.fromJson(item))
          .toList(),
    );
  }

  Future<Resource<List<LogVideo>>> watchHistory(
      {int? page, String? orderBy = 'desc'}) async {
    var resp =
        await network.get('/learning/player/list-view', queryParameters: {
      'sortBy': 'id',
      'orderBy': orderBy,
      'page': page,
    });

    return Resource(
      data: resp?.data["data"]
          .map<LogVideo>((dynamic item) => LogVideo.fromJson(item))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<MyClass>>> getMyClass({
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    int? classLevelId,
  }) async {
    var response = await network.get('/classes/player/list', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'class_level': classLevelId,
    });

    return Resource(
      data: (response?.data['data'])
          .map<MyClass>((data) => MyClass.fromJson(data))
          .toList(),
      meta: Meta(
        total: response?.data['meta']['total'],
        currentPage: response?.data['meta']['current_page'],
        lastPage: response?.data['meta']['last_page'],
      ),
    );
  }

  Future<List<ClassLevel>> getClassLevel({
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    String? option = 'paginate',
  }) async {
    var response = await network.get('/class_level/get', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'option': option,
    });

    return (response?.data['data'])
        .map<ClassLevel>((data) => ClassLevel.fromJson(data))
        .toList();
  }

  Future<void> createClass(FormData data) async {
    await network.post('/classes/insert', body: data);
  }

  Future<void> updateClass({required classId, required FormData data}) async {
    await network.post('/classes/update/$classId', body: data);
  }

  Future<Resource<List<ClassLevel>>> getClassLevels({
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    String? filter,
    String? option,
  }) async {
    var response = await network.get('/class_level/get', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'filter': filter,
      'option': option,
    });

    return Resource(
      data: (response?.data["data"] as List)
          .map<ClassLevel>((dynamic item) => ClassLevel.fromJson(item))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: response?.data['meta']['total'],
              currentPage: response?.data['meta']['current_page'],
              lastPage: response?.data['meta']['last_page'],
            ),
    );
  }

  Future<Resource<List<MyClass>>> getPlayerClassFromQRCode({
    String? code,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
  }) async {
    var response = await network.get('/report/scan/$code', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (response?.data['data'])
          .map<MyClass>((data) => MyClass.fromJson(data))
          .toList(),
      meta: Meta(
        total: response?.data['meta']['total'],
        currentPage: response?.data['meta']['current_page'],
        lastPage: response?.data['meta']['last_page'],
      ),
    );
  }
}
