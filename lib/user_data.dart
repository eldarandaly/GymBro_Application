class MyUser {
  final String email;
  final String username;
  final String password;
  final String confirmpassword;
  final String dateofbirth;
  final String gender;
  final String error;
  final String phonenumber;
  final String cholestrollevel;
  final String bloodsugar;
  final String bloodpressaure;
  final bool isAdoctor;

  MyUser(
      {required this.email,
      required this.username,
      required this.password,
      required this.dateofbirth,
      required this.bloodpressaure,
      required this.bloodsugar,
      required this.cholestrollevel,
      required this.confirmpassword,
      required this.phonenumber,
      required this.error,
      required this.gender,
      required this.isAdoctor});
}

class WhatUser {
  static String email = '';
  static String id = '';
  static String username = '';
  static String password = '';
  static String confirmpassword = '';
  static String dateofbirth = '';
  static String gender = '';
  static String error = '';
  static String phonenumber = '';
  static String cholestrollevel = '';
  static String bloodsugar = '';
  static String bloodpressaure = '';
  static bool isAdoctor = false;
  static String gradine_name = '';
  static String gradine_num = '';
}
