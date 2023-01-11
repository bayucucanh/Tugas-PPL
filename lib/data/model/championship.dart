import 'package:mobile_pssi/data/model/user.dart';

class Championship {
  int? id;
  User? user;
  String? name;
  String? position;
  String? year;

  Championship({
    this.id,
    this.user,
    this.name,
    this.position,
    this.year,
  });

  factory Championship.fromJson(Map<String, dynamic> json) => Championship(
        id: json['id'] as int?,
        name: json['name'] as String?,
        position: json['position'] as String?,
        year: json['year'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'position': position,
        'year': year,
        'user': user?.toJson(),
      };
}
