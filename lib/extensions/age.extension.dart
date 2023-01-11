extension AgeFormat on String {
  static DateTime now = DateTime.now();
  int? formatAge() {
    DateTime? dateBirth = DateTime.tryParse(this);
    if (dateBirth == null) {
      return null;
    }

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
    return age;
  }
}
