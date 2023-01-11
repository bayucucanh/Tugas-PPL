import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/championship.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class ChampionshipRequest extends NetworkBase {
  Future<Resource<List<Championship>>> gets({
    required int userId,
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/championships', queryParameters: {
      'user_id': userId,
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Championship>((data) => Championship.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> store({
    required String name,
    required String position,
    String? year,
  }) async {
    await network.post('/championships', body: {
      'name': name,
      'position': position,
      'year': year,
    });
  }

  Future<void> remove({required int id}) async {
    await network.delete('/championships/$id/delete');
  }
}
