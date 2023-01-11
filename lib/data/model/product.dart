import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/data/model/status.dart';

class Product {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  String? productId;
  String? name;
  String? description;
  double? price;
  Status? productType;
  int? value;
  String? unit;
  Status? status;
  String? currency;
  String? formattedPrice;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.productId,
    this.productType,
    this.status,
    this.unit,
    this.value,
    this.currency,
    this.formattedPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: json['price'] == null
            ? null
            : double.tryParse(json['price'].toString()),
        productId: json['product_id'] as String?,
        productType: json['type'] == null
            ? null
            : Status.fromJson(json['type'] as Map<String, dynamic>),
        unit: json['unit'] as String?,
        value: json['value'] as int?,
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
      );

  factory Product.fromIoStore(ProductDetails product) => Product(
        productId: product.id,
        name: product.title,
        description: product.description,
        price: product.rawPrice,
        currency: product.currencySymbol,
        formattedPrice: product.price,
      );

  ProductDetails toProductDetails() => ProductDetails(
        id: productId!,
        title: name!,
        description: description!,
        price: formattedPrice!,
        rawPrice: price!,
        currencyCode: currency!,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'name': name,
        'description': description,
        'price': price,
        'type': productType?.toJson(),
        'unit': unit,
        'value': value,
        'status': status?.toJson(),
      };

  String? get typeFormat => productType?.id == 1 ? 'Langganan' : 'Habis Pakai';

  String? get unitFormat {
    switch (unit) {
      case 'year':
        return 'Tahun';
      case 'month':
      default:
        return 'Bulan';
    }
  }

  String? get durationSubscription {
    if (currency != null && currency == 'IDR') {
      return '$currency $price';
    } else if (currency != null) {
      return '$currency $price';
    }
    return '$priceWithTax/$value $unitFormat';
  }

  String get priceWithTax {
    double tax = 11 / 100; // 11% tax percentage
    double priceTax = price! * tax;
    if (currency != null && currency == 'IDR') {
      return '$currency $price';
    } else if (currency != null) {
      return '$currency $price';
    }
    return _currencyFormatter.format((price! + priceTax).toStringAsFixed(0));
  }

  String? get priceFormat => price == null
      ? null
      : _currencyFormatter.format(price!.toStringAsFixed(0));
}
