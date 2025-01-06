import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<String?> getEmailFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
