import 'package:get_storage/get_storage.dart';

class GetPrefs {
  static late GetStorage _getStorage;

  static Future init() async {
    _getStorage = GetStorage();
  }

  static const String userName = "user_name";
  static const String userNumber = "user_number";
  static const String userDesignation = "user_designation";
  static const String userImage = "user_image";
  static const String userId = "id";
  static const String isLoggedIn = "is_logged_in";
  static const String theme = "theme";
  static const String projects = "projects";
  static const String notepad = "notepad";
  static const String upcomingProjects = "upcomingProjects";
  static const String canceledProjects = "canceledProjects";
  static const String ongoingProjects = "ongoingProjects";
  static const String completedProjects = "completedProjects";

  static void setString(String key, String value) {
    _getStorage.write(key, value);
  }

  static void setInt(String key, int value) {
    _getStorage.write(key, value);
  }

  static void setBool(String key, bool value) {
    _getStorage.write(key, value);
  }

  static bool containsKey(String key) {
    return _getStorage.hasData(key);
  }

  static clear() async {
    await _getStorage.erase();
  }

  static String getString(String key) {
    return _getStorage.read(key) ?? '';
  }

  static bool getBool(String key) {
    return _getStorage.read(key) ?? false;
  }

  static int getInt(String key) {
    return _getStorage.read(key) ?? 0;
  }

  static remove(String key) {
    return _getStorage.remove(key);
  }
}
