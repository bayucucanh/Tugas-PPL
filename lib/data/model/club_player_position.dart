import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';

class ClubPlayerPosition extends Equatable {
  final int? id;
  final ClubPlayer? clubPlayer;
  final PlayerPosition? playerPosition;

  const ClubPlayerPosition({this.id, this.clubPlayer, this.playerPosition});

  factory ClubPlayerPosition.fromJson(Map<String, dynamic> json) =>
      ClubPlayerPosition(
        id: json['id'] as int?,
        clubPlayer: json['club_player'] == null
            ? null
            : ClubPlayer.fromJson(json['club_player'] as Map<String, dynamic>),
        playerPosition: json['position'] == null
            ? null
            : PlayerPosition.fromJson(json['position'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'club_player': clubPlayer?.toJson(),
        'position': playerPosition?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        clubPlayer,
        playerPosition,
      ];
}
