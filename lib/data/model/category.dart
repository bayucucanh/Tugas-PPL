import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String? name;

  const Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
