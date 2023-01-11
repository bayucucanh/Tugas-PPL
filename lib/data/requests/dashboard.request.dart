import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/dashboard.dart';

class DashboardRequest extends NetworkBase {
  Future<Dashboard> getDashboardStats() async {
    var resp = await network.get('/dashboard/stats');

    return Dashboard.fromJson(resp?.data['data']);
  }
}
