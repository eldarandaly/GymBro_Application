import 'package:shared_preferences/shared_preferences.dart';

class LoginPersistence {
  static Future<void> loadLogin(LoginData loginData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    if (savedEmail != null && savedPassword != null) {
      loginData.email = savedEmail;
      loginData.password = savedPassword;
    }
  }

  static Future<void> saveLogin(LoginData loginData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', loginData.email);
    await prefs.setString('password', loginData.password);
  }

  static Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('email', '');
    // await prefs.setString('password', '');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('isLoggedIn');
  }

  static Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}

class LoginData {
  String email;
  String password;

  LoginData({required this.email, required this.password});
}
