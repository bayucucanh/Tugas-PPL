class Voucher {
  int? id;
  String? name;
  String? description;
  String? code;
  int? value;
  bool? isPercentage;
  DateTime? createdAt;

  Voucher({
    this.code,
    this.description,
    this.id,
    this.isPercentage,
    this.name,
    this.value,
    this.createdAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json['id'] as int?,
        code: json['code'] as String?,
        description: json['description'] as String?,
        name: json['name'] as String?,
        isPercentage: json['is_percentage'] == 1 ? true : false,
        value: json['value'] as int,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'code': code,
        'value': value,
        'is_percentage': isPercentage,
        'created_at': createdAt?.toIso8601String(),
      };

  String? formatValue() {
    if (value == null) {
      return null;
    }
    if (isPercentage == true) {
      return '${value ?? '-'}%';
    } else {
      return 'Rp. $value';
    }
  }
}
