import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pssi/extensions/age.extension.dart';

void main() {
  group('string format extension', () {
    test('should return a valid age', () async {
      // arrange
      final tAge = '2022-10-01'.formatAge();

      // act
      final dateBirth = DateTime.parse('2022-10-01');
      DateTime now = DateTime.now();
      int age = now.year - dateBirth.year;

      int currentMonth = now.month;
      int dateBirthMonth = dateBirth.month;

      if (dateBirthMonth > currentMonth) {
        age--;
      } else if (currentMonth == dateBirthMonth) {
        int currentDay = now.day;
        int birthDay = dateBirth.day;
        if (birthDay > currentDay) {
          age--;
        }
      }
      final result = age;
      // assert
      expect(result, tAge);
    });
  });
}
