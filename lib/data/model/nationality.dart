import 'package:equatable/equatable.dart';

class Nationality extends Equatable {
  final int? id;
  final String? code;
  final String? name;

  const Nationality({this.id, this.code, this.name});

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
        id: json['id'] as int?,
        code: json['code'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name, code];
}
