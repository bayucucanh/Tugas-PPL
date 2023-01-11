import 'package:mobile_pssi/data/model/user.dart';

class Education {
  int? id;
  User? user;
  String? schoolName;
  String? category;
  String? degree;

  Education({
    this.id,
    this.user,
    this.schoolName,
    this.category,
    this.degree,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json['id'] as int?,
        schoolName: json['school_name'] as String?,
        category: json['category'] as String?,
        degree: json['degree'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'school_name': schoolName,
        'category': category,
        'degree': degree,
        'user': user?.toJson(),
      };

  bool get isFormal => category == null
      ? false
      : category!.contains('formal')
          ? true
          : false;
}
