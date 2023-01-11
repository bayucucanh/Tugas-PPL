import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/team.dart';

class PlayerTeam extends Equatable {
  final int? id;
  final ClubPlayer? clubPlayer;
  final PlayerPosition? playerPosition;
  final Team? team;
  final int? status;

  const PlayerTeam({
    this.id,
    this.clubPlayer,
    this.team,
    this.playerPosition,
    this.status,
  });

  factory PlayerTeam.fromJson(Map<String, dynamic> json) => PlayerTeam(
        id: json['id'] as int?,
        clubPlayer: json['club_player'] == null
            ? null
            : ClubPlayer.fromJson(json['club_player'] as Map<String, dynamic>),
        team: json['team'] == null
            ? null
            : Team.fromJson(json['team'] as Map<String, dynamic>),
        playerPosition: json['position'] == null
            ? null
            : PlayerPosition.fromJson(json['position'] as Map<String, dynamic>),
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_player': clubPlayer?.toJson(),
      'team': team?.toJson(),
      'position': playerPosition?.toJson(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        clubPlayer,
        team,
        playerPosition,
        status,
      ];
}
