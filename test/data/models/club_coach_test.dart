import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/category.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/club_coach_position.dart';
import 'package:mobile_pssi/data/model/coach_position.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/user.dart';

import '../../json_reader.dart';

void main() {
  final tClubCoach = ClubCoach(
      id: 1,
      club: const Club(id: 1, name: "test"),
      employee: Employee(
        id: 1,
        name: "test",
        isOnline: false,
        gender: const Gender(id: 1, name: "test"),
        user: User(
          id: 1,
          isOnline: false,
          roles: const [],
          secureDocuments: const [],
          partnerDocuments: const [],
          specialists: const [],
        ),
        city: const City(id: 1, name: "test"),
        province: const Province(id: 1, name: "test"),
        nationality: const Nationality(id: 1, name: "test", code: "test"),
        clubCoach: const ClubCoach(id: 1),
        category: const Category(id: 1, name: "test"),
      ),
      positions: const [
        ClubCoachPosition(
          id: 1,
          clubCoach: ClubCoach(id: 1),
          coachPosition: CoachPosition(id: 1, name: "test"),
        ),
      ]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/club_coach.json'));
      // act
      final result = ClubCoach.fromJson(jsonMap);
      // assert
      expect(result, tClubCoach);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tClubCoach.toJson();
      // assert
      final Map<String, dynamic> expectedJsonMap = {
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
          "rating": null
        },
        "employee": {
          "id": 1,
          "is_online": false,
          "user_id": null,
          "user": {
            "id": 1,
            'is_online': false,
            'email': null,
            'phone_number': null,
            'employee': null,
            'player': null,
            'club': null,
            'username': null,
            'roles': [],
            'user_type': null,
            'google_id': null,
            'fb_id': null,
            'apple_id': null,
            'secure_documents': [],
            'partner_documents': [],
            'subscription': null,
            'classification_user': null,
            'coach_specialists': [],
            'suspend_user': null,
            'email_verified_at': null,
            'wallet': null,
            'created_at': null,
            'updated_at': null
          },
          "name": "test",
          'gender': {
            "id": 1,
            "name": "test",
          },
          'phone_number': null,
          'address': null,
          'date_of_birth': null,
          'city': {"id": 1, "name": "test"},
          'province': {"id": 1, "name": "test"},
          'nationality': {
            "id": 1,
            "name": "test",
            "code": "test",
          },
          'club_coach': {
            "id": 1,
            "club": null,
            "employee": null,
            "positions": null,
          },
          'category': {"id": 1, "name": "test"},
          'photo': null,
          'ktp': null,
          'nik': null
        },
        "positions": [
          {
            "id": 1,
            "club_coach": {
              "id": 1,
              'club': null,
              'employee': null,
              'positions': null
            },
            "position": {"id": 1, "name": "test"}
          }
        ]
      };

      expect(result, expectedJsonMap);
    });
  });
}
