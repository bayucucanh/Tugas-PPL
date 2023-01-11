import 'package:equatable/equatable.dart';

class Height extends Equatable {
  final String? unit;
  final double? value;

  const Height({this.unit, this.value});

  factory Height.fromJson(Map<String, dynamic> json) => Height(
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
