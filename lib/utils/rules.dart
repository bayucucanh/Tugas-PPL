class FormRules {
  static String? validate({required List<String> rules, String? value}) {
    for (String rule in rules) {
      switch (rule) {
        case 'required':
          return _required(value);
        default:
          throw Exception('Could not detect rule validation');
      }
    }
    return null;
  }

  static String? _required(String? value) {
    if (value!.isEmpty) {
      return 'Tidak boleh kosong';
    }
    return null;
  }
}
