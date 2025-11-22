import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String isFirstTimeKey = 'is_first_time';

  // Kiểm tra xem có phải lần đầu mở app không
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTimeKey) ?? true;
  }

  // Đánh dấu rằng app đã được mở
  static Future<void> setFirstTimeFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTimeKey, false);
  }
}
