import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';

class ClubCoachPosition extends Equatable {
  final int? id;
  final ClubCoach? clubCoach;
  final CoachPosition? coachPosition;

  const ClubCoachPosition({this.id, this.clubCoach, this.coachPosition});

  factory ClubCoachPosition.fromJson(Map<String, dynamic> json) =>
      ClubCoachPosition(
        id: json['id'] as int?,
        clubCoach: json['club_coach'] == null
            ? null
            : ClubCoach.fromJson(json['club_coach'] as Map<String, dynamic>),
        coachPosition: json['position'] == null
            ? null
            : CoachPosition.fromJson(json['position'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'club_coach': clubCoach?.toJson(),
        'position': coachPosition?.toJson(),
      };

  @override
  List<Object?> get props => [id, clubCoach, coachPosition];
}
