import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class PromoRequest extends NetworkBase {
  Future<Resource<List<Promotion>>> getMyPromotions({
    int? page = 1,
  }) async {
    var resp = await network.get('/promotions', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Promotion>((data) => Promotion.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Promotion> getDetail({required int promoId}) async {
    var resp = await network.get('/promotions/$promoId/detail');

    return Promotion.fromJson(resp?.data['data']);
  }

  Future<Promotion> createPromo({Map<String, dynamic>? data}) async {
    var resp = await network.post('/promotions', body: data);

    return Promotion.fromJson(resp?.data['data']);
  }

  Future<Promotion> changeStatus({required int promoId, int? status}) async {
    var resp = await network.patch('/promotions/$promoId/status', body: {
      'status': status,
    });

    return Promotion.fromJson(resp?.data['data']);
  }

  Future<Resource<List<Promotion>>> getClubPromotions({
    int? page = 1,
    String? search,
  }) async {
    var resp = await network.get('/promotions/available', queryParameters: {
      'page': page,
      'search': search,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Promotion>((data) => Promotion.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> logPromotion({
    required int promotionId,
    String? keyname,
    String? description,
  }) async {
    await network.post('/log/promotion', body: {
      'promotion_id': promotionId,
      'key_name': keyname,
      'description': description,
    });
  }

  Future<Resource<List<Promotion>>> getPromoByClubId({
    required int clubId,
    int? page = 1,
  }) async {
    var resp = await network.get('/promotions/filter/by/club/$clubId', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Promotion>((data) => Promotion.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }
}
