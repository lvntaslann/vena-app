import 'package:shared_preferences/shared_preferences.dart';

class Token {
   static Future<String?> getIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  static Future<String?> getUserName() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }
}