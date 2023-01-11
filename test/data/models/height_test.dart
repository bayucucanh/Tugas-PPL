import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/height.dart';

import '../../json_reader.dart';

void main() {
  const tHeight = Height(unit: "cm", value: 10);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/height.json'));
      // act
      final result = Height.fromJson(jsonMap);
      // assert
      expect(result, tHeight);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tHeight.toJson();
      // assert
      final expectedJsonMap = {
        "value": 10,
        "unit": "cm",
      };
      expect(result, expectedJsonMap);
    });
  });
}
