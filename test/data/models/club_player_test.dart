import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/club_player_position.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/data/model/team.dart';

import '../../json_reader.dart';

void main() {
  const tClubPlayer = ClubPlayer(
    id: 1,
    club: Club(id: 1, name: "test"),
    player: Player(id: 1, name: "test"),
    positions: [
      ClubPlayerPosition(
        id: 1,
        clubPlayer: ClubPlayer(id: 1),
        playerPosition: PlayerPosition(id: 1, name: "test"),
      ),
    ],
    playerTeam: PlayerTeam(
      id: 1,
      clubPlayer: ClubPlayer(id: 1),
      playerPosition: PlayerPosition(id: 1, name: "test"),
      status: 1,
      team: Team(id: 1, name: "test"),
    ),
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/club_player.json'));
      // act
      final result = ClubPlayer.fromJson(jsonMap);
      // assert
      expect(result, tClubPlayer);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tClubPlayer.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "club": {
          "id": 1,
          "name": "test",
          "address": null,
          "date_of_birth": null,
          "city": null,
          "province": null,
          "photo": null,
          "verified": null,
          "total_players": null,
          "rating": null,
        },
        "player": {
          "id": 1,
          "name": "test",
          "user_id": null,
          "gender": null,
          "phone_number": null,
          "address": null,
          "date_of_birth": null,
          "city": null,
          "province": null,
          "nationality": null,
          "height": null,
          "weight": null,
          "dominant_foot": null,
          "position": null,
          "photo": null,
          "parent_phone_number": null,
          "nik": null,
          "performance": null,
          "website": null,
          "club_player": null,
          "overall_rating": null,
        },
        "positions": [
          {
            "id": 1,
            "club_player": {
              "id": 1,
              "club": null,
              "player": null,
              "positions": null,
              "player_team": null,
            },
            "position": {
              "id": 1,
              "name": "test",
            },
          }
        ],
        "player_team": {
          "id": 1,
          "club_player": {
            "id": 1,
            "club": null,
            "player": null,
            "positions": null,
            "player_team": null,
          },
          "team": {
            "id": 1,
            "name": "test",
            'image_url': null,
            'blurhash': null,
            'age_group': null,
            'club': null,
            'gender': null,
            'total_coach': null,
            'total_player': null,
            'team_rate': null,
            'coach_teams': null,
            'player_teams': null,
          },
          "position": {
            "id": 1,
            "name": "test",
          },
          "status": 1,
        }
      };
      expect(result, expectedJsonMap);
    });
  });
}
