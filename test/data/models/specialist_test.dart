import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/specialist.dart';

import '../../json_reader.dart';

void main() {
  const tSpecialist =
      Specialist(id: 1, name: "test", description: "test", slug: "test");

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/specialist.json'));
      // act
      final result = Specialist.fromJson(jsonMap);
      // assert
      expect(result, tSpecialist);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSpecialist.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "test",
        "description": "test",
        "slug": "test",
      };
      expect(result, expectedJsonMap);
    });
  });
}
