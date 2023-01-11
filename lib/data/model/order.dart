import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/order_detail.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/model/user.dart';

class Order {
  final _dt = DateFormat('EEEE, dd MMM yyyy | HH:mm', 'id');
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  String? transferType;
  User? user;
  String? code;
  List<OrderDetail>? orderDetails;
  double? totalPrice;
  Status? status;
  DateTime? expired;
  String? snapToken;
  DateTime? createdAt;

  Order({
    this.id,
    this.transferType,
    this.code,
    this.orderDetails,
    this.snapToken,
    this.status,
    this.expired,
    this.totalPrice,
    this.user,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      transferType: json['transfer_type'] as String?,
      code: json['code'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      orderDetails: json['order_details'] == null
          ? null
          : (json['order_details'] as List)
              .map((e) => OrderDetail.fromJson(e))
              .toList(),
      totalPrice: json['total_price'] == null
          ? null
          : double.parse(json['total_price'].toString()),
      expired: json['expired'] == null
          ? null
          : DateTime.parse(json['expired']).toLocal(),
      status: json['payment_status'] == null
          ? null
          : Status.fromJson(json['payment_status'] as Map<String, dynamic>),
      snapToken: json['snap_token'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'transfer_type': transferType,
        'code': code,
        'user': user?.toJson(),
        'order_details': orderDetails?.map((e) => e.toJson()).toList(),
        'total_price': totalPrice,
        'expired': expired?.toIso8601String(),
        'status': status?.toJson(),
        'snap_token': snapToken,
        'created_at': createdAt?.toIso8601String(),
      };

  String? get totalPriceFormat => totalPrice == null
      ? null
      : _currencyFormatter.format(totalPrice!.toStringAsFixed(0));

  String? get createdAtFormat =>
      createdAt == null ? null : _dt.format(createdAt!);
}
