import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/withdraw.dart';

class WithdrawRequest extends NetworkBase {
  Future<Resource<List<Withdraw>>> gets({
    int? page = 1,
    String? sortBy,
    String? status,
  }) async {
    var resp = await network.get('/withdraws', queryParameters: {
      'page': page,
      'sortBy': sortBy,
      'status': status,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Withdraw>((data) => Withdraw.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> payout({
    required int bankAccountId,
    double? amount,
    String? notes,
  }) async {
    await network.post('/withdraws', body: {
      'bank_account_id': bankAccountId,
      'amount': amount,
      'notes': notes,
    });
  }

  Future<void> approve({required List<String> withdrawIds, String? otp}) async {
    await network.post('/withdraws/approve',
        body: {'withdraw_ids': withdrawIds, 'otp': otp});
  }

  Future<void> rejected(
      {required List<String> withdrawIds, String? reason}) async {
    await network.post('/withdraws/reject', body: {
      'withdraw_ids': withdrawIds,
      'reason': reason,
    });
  }
}
