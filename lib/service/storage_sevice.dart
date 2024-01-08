import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> setData(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', [email, password]);
  }

  Future<Map<String, String?>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getStringList('user')![0];
    final password = prefs.getStringList('user')![1];
    return {'email': email, 'password': password};
  }
}
