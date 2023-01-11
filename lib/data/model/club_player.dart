import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_player_position.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_team.dart';

class ClubPlayer extends Equatable {
  final int? id;
  final Club? club;
  final Player? player;
  final List<ClubPlayerPosition>? positions;
  final PlayerTeam? playerTeam;

  const ClubPlayer({
    this.id,
    this.club,
    this.player,
    this.positions,
    this.playerTeam,
  });

  factory ClubPlayer.fromJson(Map<String, dynamic> json) {
    return ClubPlayer(
      id: json['id'] as int?,
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => ClubPlayerPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      playerTeam: json['player_team'] == null
          ? null
          : PlayerTeam.fromJson(json['player_team'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club?.toJson(),
        'player': player?.toJson(),
        'positions': positions?.map((e) => e.toJson()).toList(),
        'player_team': playerTeam?.toJson(),
      };

  @override
  List<Object?> get props => [id, club, player, positions, playerTeam];
}
