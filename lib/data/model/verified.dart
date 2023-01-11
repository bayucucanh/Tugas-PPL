import 'package:equatable/equatable.dart';

class Verified extends Equatable {
  final int? id;
  final String? name;

  const Verified({this.id, this.name});

  factory Verified.fromJson(Map<String, dynamic> json) => Verified(
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
