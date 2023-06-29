// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/home/bottom_nav.dart';
import '../../sign_in/savelogin.dart';
import '/sign_in/signin.dart';
import 'package:flutter/material.dart';
import 'default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  late LoginData loginData;
  late bool isUserLoggedIn;
  late bool isUserLoggedInGoogle;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    loginData = LoginData(email: '', password: '');
    isUserLoggedIn = false;
    isUserLoggedInGoogle = false;
    checkLoginStatus();
    startTimer();
    checkLoginStatusGoogle();
    navigateToNextScreen();
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
      isUserLoggedInGoogle = isLoggedIn;
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

  void navigateToNextScreen() async {
    // Delay for 1 second
    await Future.delayed(const Duration(seconds: 1));

    if (isUserLoggedIn || isUserLoggedInGoogle) {
      // User is logged in, navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // User is not logged in, navigate to Sign In screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
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
    {
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
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: showButton(currentPage),
            // ),
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
        color: currentPage == index ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget showButton(int index) {
    if (index >= 0) {
      if (isUserLoggedIn || isUserLoggedInGoogle) {
        return Container(
          height: 70,
          width: 300,
          child: DefaultButton(
            text: "Home",
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        );
      } else {
        return Container(
          height: 70,
          width: 300,
          child: DefaultButton(
            text: "SignIn",
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
          ),
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

  const SplashContent({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.topCenter,
      children: [
        Image.asset(
          image,
          height: 500,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 500,
          left: 0,
          right: 0,
          // bottom: 2,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.openSans().fontFamily,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: Colors.blue.withOpacity(0.5),
                    offset: const Offset(2, 2),
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
