import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/model/user.dart';

class EventParticipant {
  int? id;
  String? code;
  User? user;
  Event? event;
  Team? team;

  EventParticipant({
    this.id,
    this.code,
    this.event,
    this.user,
    this.team,
  });

  factory EventParticipant.fromJson(Map<String, dynamic> json) =>
      EventParticipant(
        id: json['id'] as int?,
        code: json['code'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        event: json['event'] == null
            ? null
            : Event.fromJson(json['event'] as Map<String, dynamic>),
            team: json['team'] == null
            ? null
            : Team.fromJson(json['team'] as Map<String, dynamic>)
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'user': user?.toJson(),
        'event': event?.toJson(),
        'team': team?.toJson(),
      };
}
