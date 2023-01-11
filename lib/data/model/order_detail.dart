import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:mobile_pssi/data/model/order.dart';

class OrderDetail {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  int? productId;
  int? eventId;
  int? teamId;
  Order? order;
  String? name;
  double? price;
  int? quantity;

  OrderDetail({
    this.id,
    this.productId,
    this.teamId,
    this.name,
    this.order,
    this.price,
    this.quantity,
    this.eventId,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json['id'] as int?,
        name: json['name'] as String?,
        order: json['order'] == null
            ? null
            : Order.fromJson(json['order'] as Map<String, dynamic>),
        price: json['price'] == null
            ? null
            : double.tryParse(json['price'].toString()),
        quantity: json['quantity'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'product_id': productId,
        'event_id': eventId,
        'team_id': teamId,
        'order': order?.toJson(),
        'price': price,
        'quantity': quantity,
      };

  String? get totalPriceFormat =>
      price == null ? null : _currencyFormatter.format(price.toString());
}
