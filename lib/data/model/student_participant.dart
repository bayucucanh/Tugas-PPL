import 'package:mobile_pssi/data/model/new_student_form.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/model/player.dart';

class StudentParticipant {
  int? id;
  String? code;
  NewStudentForm? newStudentForm;
  Player? player;
  Status? status;

  StudentParticipant({
    this.id,
    this.code,
    this.newStudentForm,
    this.player,
    this.status,
  });

  factory StudentParticipant.fromJson(Map<String, dynamic> json) =>
      StudentParticipant(
        id: json['id'] as int?,
        code: json['code'] as String?,
        newStudentForm: json['new_student_form'] == null
            ? null
            : NewStudentForm.fromJson(
                json['new_student_form'] as Map<String, dynamic>),
        player: json['player'] == null
            ? null
            : Player.fromJson(json['player'] as Map<String, dynamic>),
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'new_student_form': newStudentForm?.toJson(),
        'player': player?.toJson(),
        'status': status?.toJson(),
      };

  bool filterByStatus(int filter) {
    if (status?.id == filter) {
      return true;
    }
    return false;
  }
}
