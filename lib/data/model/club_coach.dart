import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_coach_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';

class ClubCoach extends Equatable {
  final int? id;
  final Club? club;
  final Employee? employee;
  final List<ClubCoachPosition>? positions;

  const ClubCoach({
    this.id,
    this.club,
    this.employee,
    this.positions,
  });

  factory ClubCoach.fromJson(Map<String, dynamic> json) {
    return ClubCoach(
      id: json['id'] as int?,
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => ClubCoachPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club?.toJson(),
        'employee': employee?.toJson(),
        'positions': positions?.map((e) => e.toJson()).toList()
      };

  @override
  List<Object?> get props => [id, club, employee, positions];
}
