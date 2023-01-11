import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';

class SearchRequest extends NetworkBase {
  Future<Resource<List<User>>> getCoach(
      {required String search, int? limit, String? option, int? page}) async {
    var resp = await network.get('/search/coach', queryParameters: {
      'search': search,
      'limit': limit,
      'option': option,
      'page': page
    });

    return Resource(
      data: (resp?.data['data'])
          .map<User>((data) => User.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
      ),
    );
  }

  Future<Resource<List<Class>>> getClass({
    required String search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
  }) async {
    List<Class> classList = [];

    var params = {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
    };

    var response = await network.get('/search/class/', queryParameters: params);

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

  Future<Resource<List<Club>>> getClub(
      {required String search, int? limit, String? option, int? page}) async {
    var resp = await network.get('/search/club', queryParameters: {
      'search': search,
      'limit': limit,
      'option': option,
      'page': page
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Club>((data) => Club.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
      ),
    );
  }
}
