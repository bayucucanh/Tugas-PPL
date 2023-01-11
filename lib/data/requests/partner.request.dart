import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class PartnerRequest extends NetworkBase {
  Future<Resource<List<AcademyPartner>>> gets({
    String? option,
    String? sortBy,
    String? orderBy,
    int? page,
  }) async {
    var resp = await network.get('/partners', queryParameters: {
      'page': page,
      'sortBy': sortBy,
      'order_by': orderBy,
      'option': option,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<AcademyPartner>((data) => AcademyPartner.fromJson(data))
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

  Future<AcademyPartner?> detail({required int id}) async {
    var resp = await network.get('/partners/$id/detail');
    return AcademyPartner.fromJson(resp?.data['data']);
  }

  Future<AcademyPartner?> checkPartner() async {
    var resp = await network.get('/partners/check');
    if (resp?.statusCode == 200) {
      return AcademyPartner.fromJson(resp?.data['data']);
    }
    return null;
  }

  Future<void> applyPartner({FormData? data}) async {
    await network.post('/partners/apply', body: data);
  }

  Future<void> verify({
    required int partnerId,
    required int status,
    String? reason,
  }) async {
    await network.patch('/partners/verify/$partnerId', body: {
      'reason': reason,
      'status': status,
    });
  }

  Future<void> activeContentCreator({required int partnerId}) async {
    await network.patch('/partners/feature/$partnerId/course-creator');
  }

  Future<void> activeConsultation(
      {required int partnerId, required bool status}) async {
    await network.patch('/partners/feature/$partnerId/consultant', body: {
      'status': status,
    });
  }
}
