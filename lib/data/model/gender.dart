import 'package:equatable/equatable.dart';

class Gender extends Equatable {
  final int? id;
  final String? name;

  const Gender({this.id, this.name});

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
