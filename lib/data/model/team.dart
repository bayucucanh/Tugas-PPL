import 'package:avatars/avatars.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/age_group.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/player_team.dart';

class Team extends Equatable {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? blurhash;
  final AgeGroup? ageGroup;
  final Gender? gender;
  final Club? club;
  final int? totalCoach;
  final int? totalPlayers;
  final List<PlayerTeam>? players;
  final List<CoachTeam>? coaches;
  final double? teamRate;

  const Team({
    this.id,
    this.name,
    this.imageUrl,
    this.blurhash,
    this.ageGroup,
    this.gender,
    this.club,
    this.teamRate,
    this.totalCoach,
    this.totalPlayers,
    this.coaches,
    this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      blurhash: json['blurhash'] as String?,
      ageGroup: json['age_group'] == null
          ? null
          : AgeGroup.fromJson(json['age_group'] as Map<String, dynamic>),
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      gender: json['gender'] == null
          ? null
          : Gender.fromJson(json['gender'] as Map<String, dynamic>),
      totalCoach: json['total_coach'] as int?,
      totalPlayers: json['total_player'] as int?,
      teamRate: json['team_rate'] == null
          ? null
          : double.tryParse(json['team_rate'].toString()),
      coaches: (json['coach_teams'] as List<dynamic>?)
          ?.map((e) => CoachTeam.fromJson(e as Map<String, dynamic>))
          .toList(),
      players: (json['player_teams'] as List<dynamic>?)
          ?.map((e) => PlayerTeam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'blurhash': blurhash,
        'age_group': ageGroup?.toJson(),
        'club': club?.toJson(),
        'gender': gender?.toJson(),
        'total_coach': totalCoach,
        'total_player': totalPlayers,
        'coach_teams': coaches?.map((e) => e.toJson()).toList(),
        'player_teams': players?.map((e) => e.toJson()).toList(),
        'team_rate': teamRate,
      };

  Avatar? get avatar => Avatar(
        name: name,
        useCache: true,
        shape: AvatarShape.circle(50),
      );

  Color? get teamRatingColor {
    Color color = Colors.black;
    if (teamRate != null) {
      if (teamRate! >= 70 && teamRate! <= 79) {
        color = Colors.yellow;
      } else if (teamRate! >= 80 && teamRate! <= 88) {
        color = Colors.green;
      } else if (teamRate! >= 89) {
        color = primaryColor;
      }
    }
    return color;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        blurhash,
        ageGroup,
        club,
        gender,
        totalCoach,
        totalPlayers,
        teamRate,
      ];
}
