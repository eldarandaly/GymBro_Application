// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/components/socal_card.dart';
import 'package:gymbro/sign_up/sign_up_screen.dart';
import 'package:gymbro/size_config.dart';
import '../home/bottom_nav.dart';
import '/data_base/database.dart';
import '/user_data.dart';
import '../data_base/authentication.dart';
import '../regestier/register.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'savelogin.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  final DatabaseService _mod = new DatabaseService();
  String email = '';
  String password = '';
  String error = "";
  bool _passwordVisible = false;
  final AuthService _auth = new AuthService();
  // late SharedPreferences _prefs;
  LoginData loginData = LoginData(email: '', password: '');

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    // _loadSavedLogin();
    LoginPersistence.loadLogin(loginData);
  }

  // Future<void> _loadSavedLogin() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   final savedEmail = _prefs.getString('email');
  //   final savedPassword = _prefs.getString('password');
  //   if (savedEmail != null && savedPassword != null) {
  //     setState(() {
  //       email = savedEmail;
  //       password = savedPassword;
  //     });
  //   }
  // }

  // Future<void> _saveLogin() async {
  //   await _prefs.setString('email', email);
  //   await _prefs.setString('password', password);
  //   WhatUser.email = email;
  //   WhatUser.password = password;
  // }
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Get the authentication details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Use the obtained authentication details to sign in with your backend server or authenticate the user in your app
        final String? accessToken = googleAuth.accessToken;
        final String? idToken = googleAuth.idToken;

        // Create a Google credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        );
        loginData.email = googleUser.displayName!;
        loginData.password = googleUser.id;
        await LoginPersistence.saveLogin(
            loginData); // Authenticate with Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('userCredential');

// After successful login
        await LoginPersistence.saveLoginState(true);

        // Navigate to the home page

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (error) {
      // Handle the sign-in error
      // ...
      print(error);
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          // SizedBox(
          //   height: 44,
          // ),
          Center(
            child: Container(
              height: 222,
              width: 222,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/appIcon/android/play_store_512.png'))),
            ),
          ),
          Container(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("About"),
                          content: const Text(
                              "This application is Made By : ElDarandaly"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info_outline))),
          // Container(height: 20),
          Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = (val));
                          WhatUser.email = val;
                          MyUser(
                              email: email,
                              username: "username",
                              password: password,
                              dateofbirth: 'dateofbirth',
                              bloodpressaure: 'bloodpressaure',
                              bloodsugar: 'bloodsugar',
                              cholestrollevel: 'cholestrollevel',
                              confirmpassword: 'confirmpassword',
                              phonenumber: 'phonenumber',
                              error: error,
                              gender: 'gender',
                              isAdoctor: false);
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: TextFormField(
                        obscureText: !_passwordVisible,
                        validator: (val) =>
                            val!.isEmpty ? "Enter an password" : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // _mod.addUserModelData();
                            // // _mod.addUserHRlData();
                            if (_formkey.currentState!.validate()) {
                              dynamic result = await _auth
                                  .signinwithemailandpassword(email, password);
                              // print('------$result');
                              if (result == null) {
                                setState(() {
                                  error = "please enter valid information";
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: Text(
                                            'Check Your Email or Password'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                // await _saveLogin();
                                loginData.email = email;
                                loginData.password = password;
                                await LoginPersistence.saveLogin(loginData);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Pop UP"),
                                      content:
                                          Text('Welecome ${WhatUser.email}'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.login),
                          label: Text(
                            'Sign in',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.asap().fontFamily,
                                fontSize: 22),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              fixedSize: const Size.fromWidth(200.0),
                              maximumSize: const Size.fromHeight(50.0),
                              backgroundColor: Colors.blueAccent),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "or continue with social media",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocalCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () => signInWithGoogle(context),
                            ),
                            SocalCard(
                              icon: "assets/icons/facebook-2.svg",
                              press: () {
                                showAboutDialog(context: context);
                              },
                            ),
                            SocalCard(
                              icon: "assets/icons/twitter.svg",
                              press: () {},
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const register())); // transition
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             SignUpScreen())); // transition
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Need an account? ",
                                  style: TextStyle(
                                      fontFamily: GoogleFonts.asap().fontFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                TextButton(
                                  child: Text('Signup',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// import 'package:flutter_twitter_login/flutter_twitter_login.dart';




// Future<void> signInWithFacebook() async {
//   try {
//     final LoginResult result = await FacebookAuth.instance.login();

//     if (result.status == LoginStatus.success) {
//       // Get the access token
//       final String accessToken = result.accessToken!.token;

//       // Use the obtained access token to sign in with your backend server or authenticate the user in your app
//       // Perform the necessary actions after successful sign-in
//       // ...
//     } else {
//       // Handle the sign-in error
//       // ...
//     }
//   } catch (error) {
//     // Handle the sign-in error
//     // ...
//   }
// }

// Future<void> signInWithTwitter() async {
//   try {
//     final TwitterLogin twitterLogin = TwitterLogin(
//       consumerKey: 'your_consumer_key',
//       consumerSecret: 'your_consumer_secret',
//     );

//     final TwitterLoginResult result = await twitterLogin.authorize();

//     if (result.status == TwitterLoginStatus.loggedIn) {
//       // Get the authentication details
//       final String authToken = result.authToken!;
//       final String authTokenSecret = result.authTokenSecret!;

//       // Use the obtained authentication details to sign in with your backend server or authenticate the user in your app
//       // Perform the necessary actions after successful sign-in
//       // ...
//     } else {
//       // Handle the sign-in error
//       // ...
//     }
//   } catch (error) {
//     // Handle the sign-in error
//     // ...
//   }
// }
