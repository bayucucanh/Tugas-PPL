import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/suspend.dart';

class SuspendRequest extends NetworkBase {
  Future<Resource<List<Suspend>>> gets({
    int? page = 1,
    String? option,
  }) async {
    var resp = await network.get('/suspends', queryParameters: {
      'option': option,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Suspend>((data) => Suspend.fromJson(data))
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

  Future<void> create({String? name, String? duration, int? value}) async {
    await network.post('/suspends', body: {
      'name': name,
      'duration': duration,
      'value': value,
    });
  }

  Future<void> update({
    required int suspendId,
    String? name,
    String? duration,
    int? value,
  }) async {
    await network.patch('/suspends/$suspendId/update', body: {
      'name': name,
      'duration': duration,
      'value': value,
    });
  }

  Future<void> remove({
    required int suspendId,
  }) async {
    await network.delete('/suspends/$suspendId/delete');
  }

  Future<void> suspendUser({int? userId, int? suspendId}) async {
    await network.post('/suspends/user', body: {
      'suspend_id': suspendId,
      'user_id': userId,
    });
  }

  Future<void> liftSuspendUser({
    required int userId,
  }) async {
    await network.delete('/suspends/user/$userId/lift');
  }
}
