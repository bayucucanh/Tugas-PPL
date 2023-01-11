import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/academy_partner.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/status.dart';

import '../../json_reader.dart';

void main() {
  final tAcademyPartner = AcademyPartner(
    id: 1,
    employee: const Employee(
      id: 1,
      name: "test",
      isOnline: false,
    ),
    reason: "test",
    status: const Status(
      id: 1,
      name: "test",
    ),
    createdAt: DateTime.parse('2022-10-12 10:00:00').toLocal(),
    updatedAt: DateTime.parse('2022-10-12 10:00:00').toLocal(),
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/academy_partner.json'));
      // act
      final result = AcademyPartner.fromJson(jsonMap);
      // assert
      expect(result, tAcademyPartner);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tAcademyPartner.toJson();
      // assert
      final expectedJsonMap = {
        'id': 1,
        'employee': {
          'id': 1,
          'name': "test",
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
          'nik': null,
        },
        'reason': "test",
        'status': {"id": 1, "name": "test"},
        'created_at': "2022-10-12 10:00:00.000",
        'updated_at': "2022-10-12 10:00:00.000",
      };
      expect(result, expectedJsonMap);
    });
  });
}
