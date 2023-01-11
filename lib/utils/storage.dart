import 'package:get_storage/get_storage.dart';

class Storage {
  static GetStorage box = GetStorage();

  static dynamic get(String key) {
    return box.read(key);
  }

  static bool hasData(String key) {
    return box.hasData(key);
  }

  static void save(String key, dynamic value) async {
    await box.write(key, value);
  }

  static void remove(String key) async {
    await box.remove(key);
  }

  static void clearAll() async {
    await box.erase();
  }
}
