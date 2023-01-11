import 'package:equatable/equatable.dart';

class Specialist extends Equatable {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;

  const Specialist({
    this.id,
    this.description,
    this.name,
    this.slug,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) => Specialist(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        slug: json['slug'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'slug': slug,
      };

  @override
  List<Object?> get props => [id, name, description, slug];
}
