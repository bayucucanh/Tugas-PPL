import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/experience.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class ExperienceRequest extends NetworkBase {
  Future<Resource<List<Experience>>> getExperienceList({
    required int userId,
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/experience', queryParameters: {
      'user_id': userId,
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Experience>((data) => Experience.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> addExperience({required FormData data}) async {
    await network.post('/experience', body: data);
  }

  Future<void> deleteExperience({required int id}) async {
    await network.delete('/experience/$id');
  }
}
