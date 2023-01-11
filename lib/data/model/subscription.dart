import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:timeago_flutter/timeago_flutter.dart';

class Subscription {
  int? id;
  User? user;
  Product? product;
  DateTime? expired;
  DateFormat df = DateFormat('d MMMM y HH:mm:ss');

  Subscription({
    this.id,
    this.expired,
    this.product,
    this.user,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'] as int?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        product: json['product'] == null
            ? null
            : Product.fromJson(json['product'] as Map<String, dynamic>),
        expired: json['expired'] == null
            ? null
            : DateTime.parse(json['expired'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'product': product?.toJson(),
        'expired': expired?.toIso8601String(),
      };

  String? get expiredFormat {
    return expired == null ? null : df.format(expired!);
  }

  String? get expiredTime {
    timeago.setLocaleMessages('id', IdMessages());
    return expired == null
        ? null
        : timeago.format(expired!, locale: 'id', allowFromNow: true);
  }
}
