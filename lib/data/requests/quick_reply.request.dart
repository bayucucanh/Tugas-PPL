import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/quick_reply.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/observables/file_observable.dart';

class QuickReplyRequest extends NetworkBase {
  Future<Resource<List<QuickReply>>> gets({
    int? page = 1,
    String? option,
  }) async {
    var resp = await network.get('/quick-reply', queryParameters: {
      'page': page,
      'option': option,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<QuickReply>((data) => QuickReply.fromJson(data))
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

  Future<void> create({
    required String shortcut,
    String? message,
    List<FileObservable>? files,
  }) async {
    await network.post('/quick-reply',
        body: FormData.fromMap({
          'shortcut': shortcut,
          'message': message,
          'file_replies[]': files!.isEmpty
              ? null
              : files
                  .map((e) =>
                      MultipartFile.fromFileSync(e.path!, filename: e.name))
                  .toList()
        }));
  }

  Future<void> remove({
    required String quickReplyId,
  }) async {
    await network.delete('/quick-reply/$quickReplyId/delete');
  }
}
