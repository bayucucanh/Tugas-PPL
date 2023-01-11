import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/help.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class HelpRequest extends NetworkBase {
  Future<Resource<List<Help>>> gets({
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/faq', queryParameters: {
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Help>((data) => Help.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> add({String? title, String? content}) async {
    await network.post('/faq', body: {
      'title': title,
      'content': content,
    });
  }

  Future<void> remove({required String slug}) async {
    await network.delete('/faq/$slug');
  }

  Future<void> update(
      {required String slug, String? title, String? content}) async {
    await network.patch('/faq/$slug', body: {
      'title': title,
      'content': content,
    });
  }

  Future<Help> getDetail({required String slug}) async {
    var resp = await network.get('/faq/detail/$slug');

    return Help.fromJson(resp?.data['data']);
  }
}
