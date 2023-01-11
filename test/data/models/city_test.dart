import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/province.dart';

import '../../json_reader.dart';

void main() {
  const tCity = City(
    id: 1,
    name: "test",
    province: Province(id: 1, name: "test"),
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/json/city.json'));
      // act
      final result = City.fromJson(jsonMap);
      // assert
      expect(result, tCity);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tCity.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "test",
      };
      expect(result, expectedJsonMap);
    });
  });

  group('filter', () {
    test('should return a true when filter by name', () async {
      // arrange

      // act
      final result = tCity.filterByName('test');

      // assert
      const expectedResult = true;

      expect(result, expectedResult);
    });

    test('should return a false when filter by name', () async {
      // arrange

      // act

      final result = tCity.filterByName('test2');

      // assert
      const expectedResult = false;

      expect(result, expectedResult);
    });

    test('should return true when equal', () async {
      // arrange
      City expectedCity = const City(
          id: 1, name: "test", province: Province(id: 1, name: "test"));
      // act
      final result = tCity.isEqual(expectedCity);

      // assert
      const expectedResult = true;

      expect(result, expectedResult);
    });
  });

  group('display to string', () {
    test('should return a string', () async {
      // arrange

      // act
      final result = tCity.toString();

      // assert
      const expectedResult = "test";

      expect(result, expectedResult);
    });

    test('should return a province string', () async {
      // arrange

      // act
      final result = tCity.provinceAsString();

      // assert
      const expectedResult = "test";

      expect(result, expectedResult);
    });
  });
}
