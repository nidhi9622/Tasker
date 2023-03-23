import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  static Future init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
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
    _sharedPrefs!.setString(key, value);
  }

  static void setInt(String key, int value) {
    _sharedPrefs!.setInt(key, value);
  }

  static void setBool(String key, bool value) {
    _sharedPrefs!.setBool(key, value);
  }

  static bool containsKey(String key) {
    return _sharedPrefs!.containsKey(key);
  }

  static clear() async {
    await _sharedPrefs!.clear();
  }

  static String getString(String key) {
    return _sharedPrefs!.getString(key) ?? '';
  }

  static bool getBool(String key) {
    return _sharedPrefs!.getBool(key) ?? false;
  }

  static int getInt(String key) {
    return _sharedPrefs!.getInt(key) ?? 0;
  }
  static  remove(String key) {
    return _sharedPrefs!.remove(key) ;
  }
}
