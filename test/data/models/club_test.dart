import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/verified.dart';

import '../../json_reader.dart';

void main() {
  final tClub = Club(
    id: 1,
    name: "test",
    address: 'test',
    birthDate: DateTime.parse('2022-10-01 10:00:00'),
    city: const City(id: 1, name: "test"),
    photo: 'https://google.com/',
    province: const Province(id: 1, name: "test"),
    rating: 5.0,
    totalPlayers: 10,
    verified: const Verified(
      id: 1,
      name: 'test',
    ),
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/club.json'));
      // act
      final result = Club.fromJson(jsonMap);
      // assert
      expect(result, tClub);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tClub.toJson();
      // assert
      final Map<String, dynamic> expectedJsonMap = {
        "id": 1,
        "name": "test",
        "address": "test",
        "city": {"id": 1, "name": "test"},
        "date_of_birth": "2022-10-01 10:00:00.000",
        "province": {"id": 1, "name": "test"},
        "photo": "https://google.com/",
        "rating": 5.0,
        "total_players": 10,
        "verified": {"id": 1, "name": "test"}
      };

      expect(result, expectedJsonMap);
    });
  });

  group('convert Entity', () {
    test('should return a profile', () async {
      // arrange

      // act
      final result = tClub.toProfile();

      // assert
      const expectedResult = Profile(
        id: 1,
        name: "test",
        address: "test",
        dateOfBirth: "2022-10-01",
        city: City(
          id: 1,
          name: "test",
        ),
        photo: "https://google.com/",
        isPlayer: false,
      );

      expect(result, expectedResult);
    });
  });

  group('display to string', () {
    test('should return a birth date string', () async {
      // arrange

      // act
      final result = tClub.dateOfBirthInputFormat;

      // assert
      const expectedResult = "2022-10-01";

      expect(result, expectedResult);
    });

    test('should return a birth date formatted dd MMMM YYYY in indonesian',
        () async {
      // arrange

      // act
      await initializeDateFormatting();
      final result = tClub.dateOfBirthFormat;

      // assert
      const expectedResult = "01 Oktober 2022";

      expect(result, expectedResult);
    });
  });
}
