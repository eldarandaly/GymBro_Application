// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//-------------------------------------------------------------------------
  Future signinwithemailandpassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//-------------------------------------------------------------------------
  Future signupwithemailandpassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // await DatabaseService(uid: user?.uid)
      //     .updateUserData('0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
