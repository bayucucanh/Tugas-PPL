import 'package:equatable/equatable.dart';

class Weight extends Equatable {
  final String? unit;
  final double? value;

  const Weight({this.unit, this.value});

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
        unit: json['unit'] as String?,
        value: json['value'] == null
            ? null
            : double.parse(json['value'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'value': value,
      };

  @override
  List<Object?> get props => [unit, value];
}
