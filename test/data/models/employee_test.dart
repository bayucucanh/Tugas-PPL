import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/data/model/category.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/employee.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/extensions/age.extension.dart';

void main() {
  const tEmployee = Employee(
    id: 1,
    name: "test",
    address: "test",
    phoneNumber: "test",
    dateOfBirth: "2022-10-01",
    city: City(id: 1, name: "test"),
    nationality: Nationality(id: 1, code: "test", name: "test"),
    ktp: "test",
    nik: "test",
    photo: "https://google.com/",
    category: Category(id: 1, name: "Test"),
    gender: Gender(id: 1, name: 'Laki-laki'),
  );

  group('convert to entity', () {
    test('should return Profile Entity', () async {
      // arrange
      final tProfile = tEmployee.toProfile();

      // act
      const result = Profile(
        id: 1,
        name: "test",
        address: "test",
        phoneNumber: "test",
        dateOfBirth: "2022-10-01",
        city: City(id: 1, name: "test"),
        ktp: "test",
        nationality: Nationality(id: 1, code: "test", name: "test"),
        nik: "test",
        photo: "https://google.com/",
        category: Category(id: 1, name: "Test"),
        gender: Gender(id: 1, name: 'Laki-laki'),
        isPlayer: false,
      );

      // assert
      expect(result, tProfile);
    });
  });

  group('additional attribute check', () {
    test('should return age value', () async {
      // arrange
      final tAge = tEmployee.age;

      // act

      final result = '${'2022-10-01'.formatAge() ?? 0} tahun';

      // assert
      expect(result, tAge);
    });
  });
}
