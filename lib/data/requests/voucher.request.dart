import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';

class VoucherRequest extends NetworkBase {
  Future<Resource<List<Voucher>>> gets(
      {String? search, int? page = 1, String? target}) async {
    var resp = await network.get('/vouchers', queryParameters: {
      'page': page,
      'search': search,
      'target': target,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Voucher>((data) => Voucher.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> create({
    required String name,
    String? description,
    String? target,
    required String code,
    required int value,
    required bool isPercentage,
    DateTime? validFrom,
    DateTime? expired,
  }) async {
    await network.post('/vouchers', body: {
      'name': name,
      'description': description,
      'target': target,
      'code': code,
      'value': value,
      'is_percentage': isPercentage,
      'valid_from': validFrom?.toIso8601String(),
      'expired': expired?.toIso8601String(),
    });
  }

  Future<void> delete({required int voucherId}) async {
    await network.delete('/vouchers/$voucherId/delete');
  }

  Future<Voucher> applyVoucher({required String voucherCode}) async {
    var resp = await network.get('/vouchers/apply/$voucherCode');

    return Voucher.fromJson(resp?.data['data']);
  }
}
