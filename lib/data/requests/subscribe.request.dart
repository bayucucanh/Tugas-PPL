import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/subscribe_receipt.dart';
import 'package:mobile_pssi/data/model/subscription.dart';

class SubscribeRequest extends NetworkBase {
  Future<bool> hasSubscribe() async {
    var resp = await network.get('/subscribe');
    if (resp?.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Resource<List<SubscribeReceipt>>> paymentHistory(
      {int? page = 1}) async {
    var resp = await network.get('/subscribe/all', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<SubscribeReceipt>((data) => SubscribeReceipt.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> subscribePlayer(
      {required String orderId, required String productId}) async {
    await network.post('/subscribe/player', body: {
      'order_id': orderId,
      'product_id': productId,
    });
  }

  Future<void> subscribeClub(
      {required String orderId, required String productId}) async {
    await network.post('/subscribe/club', body: {
      'order_id': orderId,
      'product_id': productId,
    });
  }

  Future<bool> hasActiveSubscribe({required List<int> productIds}) async {
    var resp = await network.post('/subscribe/check', body: {
      'product_ids': productIds,
    });

    if (resp?.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Resource<List<Subscription>>> activeSubscriptions(
      {int? page = 1}) async {
    var resp = await network.get('/subscribe/active/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Subscription>((data) => Subscription.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<Resource<List<Subscription>>> inactiveSubscriptions(
      {int? page = 1}) async {
    var resp = await network.get('/subscribe/inactive/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Subscription>((data) => Subscription.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }
}
