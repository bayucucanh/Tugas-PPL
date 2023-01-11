import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/bank_account.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class BankAccountRequest extends NetworkBase {
  Future<Resource<List<BankAccount>>> gets({
    int? page = 1,
    String? option,
    String? sortBy,
  }) async {
    var resp = await network.get('/bank-accounts', queryParameters: {
      'page': page,
      'option': option,
      'sortBy': sortBy,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<BankAccount>((data) => BankAccount.fromJson(data))
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

  Future<Resource<List<BankAccount>>> supportedBanks() async {
    var resp = await network.get('/bank-accounts/supported');

    return Resource(
      data: (resp?.data['data'] as List)
          .map<BankAccount>((data) => BankAccount.fromJson(data))
          .toList(),
      meta: null,
    );
  }

  Future<void> store({
    String? accountNumber,
    String? bankCode,
  }) async {
    await network.post('/bank-accounts', body: {
      'account_number': accountNumber,
      'bank_code': bankCode,
    });
  }

  Future<void> update({
    required int bankAccountId,
    String? accountNumber,
    String? bankCode,
  }) async {
    await network.patch('/bank-accounts/$bankAccountId/update', body: {
      'account_number': accountNumber,
      'bank_code': bankCode,
    });
  }
}
