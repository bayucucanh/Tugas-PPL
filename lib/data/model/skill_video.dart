import 'package:mobile_pssi/data/model/skill.dart';

class SkillVideo {
  int? id;
  Skill? skill;

  SkillVideo({this.id, this.skill});

  factory SkillVideo.fromJson(Map<String, dynamic> json) => SkillVideo(
        id: json['id'] as int?,
        skill: json['skill'] == null
            ? null
            : Skill.fromJson(json['skill'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'skill': skill?.toJson(),
      };

  @override
  String toString() {
    return skill == null ? 'null' : skill!.name!;
  }
}
