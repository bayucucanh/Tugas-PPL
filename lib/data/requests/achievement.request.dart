import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/achievement.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class AchievementRequest extends NetworkBase {
  Future<Resource<List<Achievement>>> gets({
    required int userId,
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/achievements', queryParameters: {
      'user_id': userId,
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Achievement>((data) => Achievement.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> store({required String name, String? year}) async {
    await network.post('/achievements', body: {
      'name': name,
      'year': year,
    });
  }

  Future<void> update(
      {required int achievementId, String? name, String? year}) async {
    await network.patch('/achievements/$achievementId/update', body: {
      'name': name,
      'year': year,
    });
  }

  Future<void> remove({required int id}) async {
    await network.delete('/achievements/$id/delete');
  }
}
