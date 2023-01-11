import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/selection_form.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/player.dart';

class SelectionParticipant {
  int? id;
  String? code;
  SelectionForm? selectionForm;
  Player? player;
  Employee? employee;
  Status? status;

  SelectionParticipant({
    this.employee,
    this.code,
    this.id,
    this.player,
    this.selectionForm,
    this.status,
  });

  factory SelectionParticipant.fromJson(Map<String, dynamic> json) =>
      SelectionParticipant(
        id: json['id'] as int?,
        code: json['code'] as String?,
        selectionForm: json['selection_form'] == null
            ? null
            : SelectionForm.fromJson(
                json['selection_form'] as Map<String, dynamic>),
        employee: json['employee'] == null
            ? null
            : Employee.fromJson(json['employee'] as Map<String, dynamic>),
        player: json['player'] == null
            ? null
            : Player.fromJson(json['player'] as Map<String, dynamic>),
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
      );

  Profile? get profile {
    if (employee != null) {
      return employee?.toProfile();
    } else {
      return player?.toProfile();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'selection_form': selectionForm?.toJson(),
        'player': player?.toJson(),
        'employee': employee?.toJson(),
        'status': status?.toJson(),
      };

  bool filterByStatus(int filter) {
    if (status?.id == filter) {
      return true;
    }
    return false;
  }
}
