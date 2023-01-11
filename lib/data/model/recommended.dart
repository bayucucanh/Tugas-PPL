import 'package:equatable/equatable.dart';

class Recommended extends Equatable {
  final int? id;
  final String? name;

  const Recommended({this.id, this.name});

  factory Recommended.fromJson(Map<String, dynamic> json) {
    return Recommended(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
