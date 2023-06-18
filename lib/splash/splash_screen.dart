import 'package:flutter/material.dart';
import 'package:gymbro/sign_in/signin.dart';
import '../home/bottom_nav.dart';
import 'components/body.dart';
import '/size_config.dart';
import 'package:gymbro/sign_in/savelogin.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // late LoginData loginData;
//   // late bool isUserLoggedIn;

//   @override
//   void initState() {
//     super.initState();
//     // loginData = LoginData(email: '', password: '');
//     // isUserLoggedIn = false;
//     // checkLoginStatus();
//   }

// Future<void> checkLoginStatus() async {
//   await LoginPersistence.loadLogin(loginData);
//   isUserLoggedIn = isLoggedIn();
//   await Future.delayed(const Duration(seconds: 2));
//   navigateToNextScreen();
// }

// bool isLoggedIn() {
//   return loginData.email.isNotEmpty && loginData.password.isNotEmpty;
// }

// void navigateToNextScreen() {
//   print(isUserLoggedIn);
//   if (isUserLoggedIn) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HomePage(),
//       ),
//     );
//   } else {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SignIn(),
//       ),
//     );
//   }
// }

// @override
// void dispose() {
//   LoginPersistence.saveLogin(loginData);
//   super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     // Customize your splash screen UI here
//     return Scaffold(body: Body());
//   }
// }
// class SplashScreen extends StatelessWidget {
//   static String routeName = "/splash";
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return const Scaffold(
//       body: Body(),
//     );
//   }
// }
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
