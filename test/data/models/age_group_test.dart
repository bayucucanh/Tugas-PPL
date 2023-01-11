import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/age_group.dart';

import '../../json_reader.dart';

void main() {
  const tAgeGroup = AgeGroup(id: 1, name: "test");

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/age_group.json'));
      // act
      final result = AgeGroup.fromJson(jsonMap);
      // assert
      expect(result, tAgeGroup);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tAgeGroup.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "test",
      };
      expect(result, expectedJsonMap);
    });
  });
}
