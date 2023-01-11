import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/age_group.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/coach_team.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/player_team.dart';
import 'package:mobile_pssi/data/model/team.dart';

import '../../json_reader.dart';

void main() {
  const tCoachTeam = CoachTeam(
    id: 1,
    coach: Employee(id: 1, isOnline: false, name: "test"),
    coachPosition: CoachPosition(id: 1, name: "test"),
    status: 1,
    team: Team(
        id: 1,
        name: "test",
        ageGroup: AgeGroup(id: 1, name: "test"),
        club: Club(id: 1, name: "test"),
        teamRate: 100,
        gender: Gender(id: 1, name: "test"),
        coaches: [
          CoachTeam(id: 1),
        ],
        players: [
          PlayerTeam(id: 1),
        ]),
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/coach_team.json'));
      // act
      final result = CoachTeam.fromJson(jsonMap);
      // assert
      expect(result, tCoachTeam);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tCoachTeam.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "coach": {
          "id": 1,
          "name": "test",
          "is_online": false,
          'user_id': null,
          'user': null,
          'gender': null,
          'phone_number': null,
          'address': null,
          'date_of_birth': null,
          'city': null,
          'province': null,
          'nationality': null,
          'club_coach': null,
          'category': null,
          'photo': null,
          'ktp': null,
          'nik': null
        },
        "team": {
          "id": 1,
          "name": "test",
          'image_url': null,
          'blurhash': null,
          'age_group': {
            "id": 1,
            "name": "test",
          },
          'club': {
            'id': 1,
            'name': 'test',
            'address': null,
            'date_of_birth': null,
            'city': null,
            'province': null,
            'photo': null,
            'verified': null,
            'total_players': null,
            'rating': null
          },
          'gender': {"id": 1, "name": "test"},
          'coach_teams': [
            {
              "id": 1,
              'coach': null,
              'team': null,
              'position': null,
              'status': null,
            }
          ],
          'player_teams': [
            {
              "id": 1,
              'club_player': null,
              'team': null,
              'position': null,
              'status': null
            }
          ],
          'team_rate': 100,
          "total_coach": null,
          "total_player": null,
        },
        "position": {
          "id": 1,
          "name": "test",
        },
        "status": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
