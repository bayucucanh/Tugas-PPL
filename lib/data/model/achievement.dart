import 'package:mobile_pssi/data/model/user.dart';

class Achievement {
  int? id;
  User? user;
  String? name;
  String? year;

  Achievement({
    this.id,
    this.name,
    this.user,
    this.year,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'] as int?,
        name: json['name'] as String?,
        year: json['year'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'year': year,
        'user': user?.toJson(),
      };
}
