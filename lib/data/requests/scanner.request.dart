import 'package:mobile_pssi/base/network.base.dart';

class ScannerRequest extends NetworkBase {
  Future<String?> getCodeType({
    String? code,
  }) async {
    var resp = await network.get('/scan/$code');

    return resp?.data['data']['type'];
  }
}
