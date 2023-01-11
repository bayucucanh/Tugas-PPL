import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/order.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';

class OrderRequest extends NetworkBase {
  Future<Resource<List<Order>>> gets({int? page, String? option}) async {
    var resp = await network.get('/orders/my', queryParameters: {
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Order>((data) => Order.fromJson(data))
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

  Future<Order> create({required Order order, Voucher? voucher}) async {
    var resp = await network.post('/orders', body: {
      'total_price': order.totalPrice,
      'item_details': order.orderDetails?.map((e) => e.toJson()).toList(),
      'voucher_code': voucher?.code,
    });

    return Order.fromJson(resp?.data['data']);
  }

  Future<Order> getOrder({required Order order}) async {
    var resp = await network.get('/orders/${order.id}');

    return Order.fromJson(resp?.data['data']);
  }

  Future<void> changeOrderStatus(
      {required String orderId, required int status}) async {
    await network.patch('/orders/status/$orderId', body: {
      'status': status,
    });
  }

  Future<void> freeOrder({required String orderCode}) async {
    await network.post('/orders/free', body: {
      'order_code': orderCode,
    });
  }

  Future<void> validateReceipt({
    required PurchaseDetails purchase,
    required double price,
  }) async {
    await network.post('/orders/validate/receipt', body: {
      'source': purchase.verificationData.source,
      'receipt': purchase.verificationData.serverVerificationData,
      'product_id': purchase.productID,
      'price': price,
    });
  }
}
