import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/team.dart';

class CoachTeam extends Equatable {
  final int? id;
  final Employee? coach;
  final Team? team;
  final CoachPosition? coachPosition;
  final int? status;

  const CoachTeam({
    this.id,
    this.coach,
    this.team,
    this.coachPosition,
    this.status,
  });

  factory CoachTeam.fromJson(Map<String, dynamic> json) => CoachTeam(
        id: json['id'] as int?,
        coach: json['coach'] == null
            ? null
            : Employee.fromJson(json['coach'] as Map<String, dynamic>),
        team: json['team'] == null
            ? null
            : Team.fromJson(json['team'] as Map<String, dynamic>),
        coachPosition: json['position'] == null
            ? null
            : CoachPosition.fromJson(json['position'] as Map<String, dynamic>),
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coach': coach?.toJson(),
      'team': team?.toJson(),
      'position': coachPosition?.toJson(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, coach, team, coachPosition, status];
}
