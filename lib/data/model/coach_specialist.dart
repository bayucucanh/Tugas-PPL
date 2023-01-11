import 'package:mobile_pssi/data/model/specialist.dart';
import 'package:mobile_pssi/data/model/user.dart';

class CoachSpecialist {
  int? id;
  User? user;
  Specialist? specialist;

  CoachSpecialist({
    this.id,
    this.specialist,
    this.user,
  });

  factory CoachSpecialist.fromJson(Map<String, dynamic> json) =>
      CoachSpecialist(
        id: json['id'] as int?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        specialist: json['specialist'] == null
            ? null
            : Specialist.fromJson(json['specialist'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'specialist': specialist?.toJson(),
      };
}
