import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/education.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class EducationRequest extends NetworkBase {
  Future<Resource<List<Education>>> gets({
    required int userId,
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/recent-educations', queryParameters: {
      'user_id': userId,
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Education>((data) => Education.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> store({
    required String schoolName,
    required String category,
    String? degree,
  }) async {
    await network.post('/recent-educations', body: {
      'school_name': schoolName,
      'category': category,
      'degree': degree,
    });
  }

  Future<void> remove({required int id}) async {
    await network.delete('/recent-educations/$id/delete');
  }
}
