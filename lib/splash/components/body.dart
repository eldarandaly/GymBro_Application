// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/home/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sign_in/savelogin.dart';
import '../../size_config.dart';
import 'constants.dart';
import '/sign_in/signin.dart';
import 'package:flutter/material.dart';

// This is the best practice
import '../components/splash_content.dart';
// import '../../../components/default_button.dart';
import 'default_button.dart';

// class Body extends StatefulWidget {
//   const Body({Key? key}) : super(key: key);

//   @override
//   _BodyState createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   late LoginData loginData;
//   late bool isUserLoggedIn;
//   int currentPage = 0;
//   List splashTitle = [
//     {
//       "boldTitle": "Want to build Nice Body",
//     },
//     {
//       "boldTitle": "Need to Lose 4 inches from Ardaf",
//     },
//     // {
//     //   "boldTitle": "Need To Have a Chiseled Abs",
//     // },
//     {
//       "boldTitle": "I Got You",
//     },
//   ];
//   List splashData = [
//     {
//       "text":
//           "Strength doesn't come from what you can do. It comes from overcoming the things you once thought you couldn't.",
//       "image": "assets/Gym/img1.jpg",
//     },
//     {
//       "text": "The only bad workout is the one that didn't happen.",
//       "image": "assets/Gym/img2.jpg",
//     },
//     // {
//     //   "text": "Success starts with self-discipline.",
//     //   "image": "assets/Gym/img3.jpeg",
//     // },
//     {
//       "text":
//           "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
//       "image": "assets/Gym/img.jpeg",
//     },
//   ];

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     loginData = LoginData(email: '', password: '');
//     isUserLoggedIn = false;
//     checkLoginStatus();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void checkLoginStatus() async {
//     await LoginPersistence.loadLogin(loginData);
//     isUserLoggedIn = isLoggedIn();
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {});
//   }

//   bool isLoggedIn() {
//     return loginData.email.isNotEmpty && loginData.password.isNotEmpty;
//   }

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       refresh();
//     });
//   }

//   void refresh() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);

//     return SafeArea(
//       child: SizedBox(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               flex: 2,
//               child: PageView.builder(
//                 onPageChanged: ((value) {
//                   setState(() {
//                     currentPage = value;
//                   });
//                 }),
//                 itemCount: splashData.length,
//                 itemBuilder: (context, index) => SplashContent(
//                   headtitle: splashTitle[index]["boldTitle"],
//                   image: splashData[index]["image"],
//                   text: splashData[index]["text"],
//                 ),
//               ),
//             ),
//             Container(
//               height: 80,
//               child: Column(
//                 children: <Widget>[
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       splashData.length,
//                       (index) => buildDot(index: index),
//                     ),
//                   ),
//                   const Spacer(flex: 1),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   showButton(currentPage),
//                   Spacer(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   AnimatedContainer buildDot({required int index}) {
//     return AnimatedContainer(
//       duration: kAnimationDuration,
//       margin: const EdgeInsets.only(right: 5),
//       height: 6,
//       width: currentPage == index ? 20 : 6,
//       decoration: BoxDecoration(
//         color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
//         borderRadius: BorderRadius.circular(3),
//       ),
//     );
//   }

//   Widget showButton(index) {
//     if (index == 0) {
//       if (isUserLoggedIn) {
//         return Container(
//           height: 50,
//           width: 300,
//           child: DefaultButton(
//               text: "Home",
//               press: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => HomePage()));
//               }),
//         );
//       } else {
//         return Container(
//           height: 50,
//           width: 300,
//           child: DefaultButton(
//               text: "SiginIn",
//               press: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => SignIn()));
//               }),
//         );
//       }
//     } else {
//       return Container();
//     }
//   }
// }
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  late LoginData loginData;
  late bool isUserLoggedIn;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    loginData = LoginData(email: '', password: '');
    isUserLoggedIn = false;
    checkLoginStatus();
    startTimer();
    checkLoginStatusGoogle();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void checkLoginStatus() async {
    await LoginPersistence.loadLogin(loginData);
    isUserLoggedIn = isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  void checkLoginStatusGoogle() async {
    bool isLoggedIn = await LoginPersistence.loadLoginState();
    setState(() {
      isUserLoggedIn = isLoggedIn;
    });
  }

  bool isLoggedIn() {
    return loginData.email.isNotEmpty && loginData.password.isNotEmpty;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      refresh();
    });
  }

  void refresh() {
    setState(() {});
  }

  final List<Map<String, String>> splashData = [
    {
      "text":
          "Strength doesn't come from what you can do. It comes from overcoming the things you once thought you couldn't.",
      "image": "assets/Gym/img1.jpg",
    },
    {
      "text": "The only bad workout is the one that didn't happen.",
      "image": "assets/Gym/img2.jpg",
    },
    // {
    //   "text": "Success starts with self-discipline.",
    //   "image": "assets/Gym/img3.jpeg",
    // },
    {
      "text":
          "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
      "image": "assets/Gym/img.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (isUserLoggedIn) {
      return HomePage();
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]['image']!,
                  text: splashData[index]['text']!,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => buildDot(index),
              ),
            ),
            showButton(currentPage),
          ],
        ),
      );
    }
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget showButton(index) {
    if (index >= 0) {
      if (isUserLoggedIn) {
        return Container(
          height: 70,
          width: 300,
          child: DefaultButton(
              text: "Home",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }),
        );
      } else {
        return Container(
          height: 70,
          width: 300,
          child: DefaultButton(
              text: "SiginIn",
              press: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              }),
        );
      }
    } else {
      return Container();
    }
  }
}

class SplashContent extends StatelessWidget {
  final String image;
  final String text;

  SplashContent({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          image,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 500,
          left: 0,
          right: 0,
          bottom: 2,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.bebasNeue().fontFamily,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
