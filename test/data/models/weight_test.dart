import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/weight.dart';

import '../../json_reader.dart';

void main() {
  const tWeight = Weight(unit: "kg", value: 10);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/weight.json'));
      // act
      final result = Weight.fromJson(jsonMap);
      // assert
      expect(result, tWeight);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tWeight.toJson();
      // assert
      final expectedJsonMap = {
        "value": 10,
        "unit": "kg",
      };
      expect(result, expectedJsonMap);
    });
  });
}
