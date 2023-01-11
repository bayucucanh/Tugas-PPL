import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/dominant_foot.dart';

import '../../json_reader.dart';

void main() {
  const tDominantFoot = DominantFoot(id: 1, name: "test");

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/dominant_foot.json'));
      // act
      final result = DominantFoot.fromJson(jsonMap);
      // assert
      expect(result, tDominantFoot);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tDominantFoot.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "test",
      };
      expect(result, expectedJsonMap);
    });
  });
}
