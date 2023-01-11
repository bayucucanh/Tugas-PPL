import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final int? id;
  final String? name;
  final String? slug;

  const Role({this.id, this.name, this.slug});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] as int?,
        name: json['name'] as String?,
        slug: json['slug'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
      };

  @override
  List<Object?> get props => [id, name, slug];
}
