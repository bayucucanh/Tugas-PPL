import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/role.dart';

import '../../json_reader.dart';

void main() {
  const tRole = Role(id: 1, name: "Admin", slug: "admin");

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/role.json'));
      // act
      final result = Role.fromJson(jsonMap);
      // assert
      expect(result, tRole);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tRole.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "Admin",
        "slug": "admin",
      };
      expect(result, expectedJsonMap);
    });
  });
}
