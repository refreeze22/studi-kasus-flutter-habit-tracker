import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String usernameKey = 'username';
  static const String themeModeKey = 'theme_mode';
  static const String isOnboardedKey = 'is_onboarded';

  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeModeKey, isDarkMode);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeModeKey) ?? false;
  }

  static Future<void> setOnboarded(bool isOnboarded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isOnboardedKey, isOnboarded);
  }

  static Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isOnboardedKey) ?? false;
  }
}
