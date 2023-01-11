import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/skill.dart';
import 'package:mobile_pssi/observables/file_observable.dart';

class SkillRequest extends NetworkBase {
  Future<Resource<List<Skill>>> getSkills(
      {int? limit = 10, int? page = 1, String? option = 'select'}) async {
    var resp = await network.get('/skill/get', queryParameters: {
      'option': option,
      'limit': limit,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Skill>((data) => Skill.fromJson(data))
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

  Future<void> create(
      {String? name, String? description, FileObservable? image}) async {
    await network.post(
      '/skill',
      body: FormData.fromMap({
        'name': name,
        'description': description,
        'image': image?.path == null
            ? null
            : await MultipartFile.fromFile(image!.path!, filename: image.name),
      }),
    );
  }

  Future<void> update({
    required int skillId,
    String? name,
    String? description,
  }) async {
    await network.patch('/skill/$skillId/update', body: {
      'name': name,
      'description': description,
    });
  }

  Future<void> remove({
    required int skillId,
  }) async {
    await network.delete('/skill/$skillId/delete');
  }
}
