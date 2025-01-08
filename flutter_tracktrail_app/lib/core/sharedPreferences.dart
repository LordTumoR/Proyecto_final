import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<String?> getEmailFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}

// import 'package:encrypt_shared_preferences/provider.dart';

// class PreferencesHelper {
//   static Future<String?> getEmailFromPreferences() async {
//     const key = "";
//     await EncryptedSharedPreferences.initialize(key: key);
//     final prefs = await EncryptedSharedPreferences.getInstance();
//     return prefs.getString('email');
//   }
// }
