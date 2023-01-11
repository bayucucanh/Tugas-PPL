import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/user.dart';

class SubscribeReceipt {
  int? id;
  User? user;
  String? productId;
  String? transactionId;
  DateTime? transactionDate;
  DateTime? expired;
  double? price;
  String? currency;
  bool? isCancel;
  String? cancelReason;

  SubscribeReceipt({
    this.id,
    this.user,
    this.expired,
    this.productId,
    this.transactionDate,
    this.transactionId,
    this.cancelReason,
    this.currency,
    this.isCancel,
    this.price,
  });

  factory SubscribeReceipt.fromJson(Map<String, dynamic> json) =>
      SubscribeReceipt(
        id: json['id'] as int?,
        productId: json['product_id'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        transactionId: json['transaction_id'] as String?,
        transactionDate: json['transaction_date'] == null
            ? null
            : DateTime.parse(json['transaction_date'].toString()).toLocal(),
        expired: json['expired'] == null
            ? null
            : DateTime.parse(json['expired'].toString()).toLocal(),
        cancelReason: json['cancel_reason'] as String?,
        currency: json['currency'] as String?,
        isCancel: json['is_cancel'] == null
            ? null
            : json['is_cancel'] == 0
                ? false
                : true,
        price: json['price'] == null
            ? null
            : double.tryParse(json['price'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'user': user?.toJson(),
        'transaction_id': transactionId,
        'transaction_date': transactionDate?.toIso8601String(),
        'expired': expired?.toIso8601String(),
        'price': price,
        'currency': currency,
        'is_cancel': isCancel,
        'cancel_reason': cancelReason,
      };

  String? get formatPrice {
    if (price != null) {
      NumberFormat formatter = NumberFormat.currency(
          customPattern: '#,##0.00', name: currency, decimalDigits: 0);
      return formatter.format(price! / 1000000.0);
    }
    return null;
  }

  bool? get isExpired {
    if (expired != null) {
      DateTime now = DateTime.now();
      if (expired!.difference(now).isNegative) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  String? get reasonCanceled {
    if (cancelReason != null) {
      switch (cancelReason) {
        case '0':
          return 'Dibatalkan oleh pengguna';
        case '1':
          return 'Dibatalkan oleh sistem';
        case '2':
          return 'Dibatalkan untuk diganti';
        case '3':
          return 'Dibatalkan oleh pengembang';
      }
    }
    return null;
  }
}
