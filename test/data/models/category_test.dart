import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/category.dart';

import '../../json_reader.dart';

void main() {
  const tCategory = Category(id: 1, name: "test");

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/category.json'));
      // act
      final result = Category.fromJson(jsonMap);
      // assert
      expect(result, tCategory);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tCategory.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "test",
      };
      expect(result, expectedJsonMap);
    });
  });
}
