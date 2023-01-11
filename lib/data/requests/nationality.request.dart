import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/nationality.dart';

class NationalityRequest extends NetworkBase {
  Future<Resource<List<Nationality>>> getNationality() async {
    var response = await network
        .get('/national/get', queryParameters: {'option': 'select'});

    return Resource(
      data: (response?.data['data'])
          .map<Nationality>((data) => Nationality.fromJson(data))
          .toList(),
    );
  }
}
