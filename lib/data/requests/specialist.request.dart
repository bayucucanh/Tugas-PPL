import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/specialist.dart';

class SpecialistRequest extends NetworkBase {
  Future<Resource<List<Specialist>>> gets({
    String? option,
    int? page,
  }) async {
    var resp = await network.get('/specialists', queryParameters: {
      'option': option,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Specialist>((data) => Specialist.fromJson(data))
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
}
