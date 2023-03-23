// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPrefs {
//   static String newName = 'newName';
//   static SharedPrefs sharedPref = SharedPrefs._();
//   static late SharedPreferences _preferences;
//
//   Future _init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }
//
//   factory SharedPrefs()  {
//     Future.microtask(()async{
//      await sharedPref._init();
//     });
//     return sharedPref;
//   }
//
//   SharedPrefs._();
//   setName(String key, String value) {
//     print('name set');
//     _preferences.setString(key, value);
//   }
//   getName(){
//     return _preferences.getString(newName);
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // static SharedPrefs sharedPrefs = SharedPrefs._();
  // SharedPrefs._();

  static SharedPreferences? _sharedPrefs;

  static Future init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  static const String userName = "user_name";
  static const String userNumber = "user_number";
  static const String userDesignation = "user_designation";
  static const String userImage = "user_image";
  static const String userId = "user_id";
  static const String isLoggedIn = "is_logged_in";
  static const String theme = "theme";

  static void setString(String key, String value) {
    _sharedPrefs!.setString(key, value);
  }

  static void setInt(String key, int value) {
    _sharedPrefs!.setInt(key, value);
  }

  static void setBool(String key, bool value) {
    _sharedPrefs!.setBool(key, value);
  }

  static bool containKey(
    String key,
  ) {
    return _sharedPrefs!.containsKey(key);
  }

  static clear() async {
    await _sharedPrefs!.clear();
  }

  static String getString(String key) {
    return _sharedPrefs!.getString(key) ?? 'NA';
  }

  static bool getBool(String key) {
    return _sharedPrefs!.getBool(key) ?? false;
  }

  static bool getInt(String key) {
    return _sharedPrefs!.getBool(key) ?? false;
  }
}
