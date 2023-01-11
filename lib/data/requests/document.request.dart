import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/secure_document.dart';
import 'package:mobile_pssi/data/model/user.dart';

class DocumentRequest extends NetworkBase {
  Future<Resource<List<SecureDocument>>> getSecureDocuments({
    required int? playerId,
    int? limit,
    int? page = 1,
    String? option = 'select',
  }) async {
    var resp = await network
        .get('/secure-documents/player/$playerId', queryParameters: {
      'limit': limit,
      'page': page,
      'option': option,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<SecureDocument>((data) => SecureDocument.fromJson(data))
          .toList(),
      meta: option != null
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<Resource<List<User>>> getUnverifiedSecureDocuments({
    int? limit,
    int? page = 1,
    String? option,
  }) async {
    var resp = await network.get('/secure-documents/users', queryParameters: {
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<User>((data) => User.fromJson(data))
          .toList(),
      meta: option != null
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<Resource<List<SecureDocument>>> getUserDocuments({
    required int userId,
    int? limit,
    int? page = 1,
    String? option,
  }) async {
    var resp =
        await network.get('/secure-documents/users/$userId', queryParameters: {
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<SecureDocument>((data) => SecureDocument.fromJson(data))
          .toList(),
      meta: option != null
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<void> updateStatus({required int documentId, int? status}) async {
    await network.patch('/secure-documents/$documentId/update', body: {
      'status': status,
    });
  }
}
