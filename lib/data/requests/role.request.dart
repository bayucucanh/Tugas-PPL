import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/role.dart';

class RoleRequest extends NetworkBase {
  Future<Resource<List<Role>>> getRoles({
    String? search,
    int? page = 1,
    String? option,
  }) async {
    var resp = await network.get('/roles', queryParameters: {
      'page': page,
      'option': option,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Role>((data) => Role.fromJson(data))
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
}
