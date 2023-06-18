import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/sign_in/savelogin.dart';
import 'package:gymbro/sign_in/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

final today = DateUtils.dateOnly(DateTime.now());

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences _prefs;
  String? _imageData;
  late LoginData loginData;
  late bool isUserLoggedIn;
  late ValueNotifier<DateTime> _selectedDate;

  late List<DateTime?> _dates = [];

  Future<List<DateTime?>> getSavedDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dateTimeStrings = prefs.getStringList('workoutDates');

    if (dateTimeStrings != null) {
      _dates = dateTimeStrings.map((dateTimeString) {
        return DateTime.parse(dateTimeString);
      }).toList();
    } else {
      _dates = [];
    }

    return _dates;
  }

  @override
  void initState() {
    super.initState();
    loadProfileImage();
    loginData = LoginData(email: '', password: '');
    isUserLoggedIn = false;
    checkLoginStatus();
    getSavedDates();
  }

  void checkLoginStatus() async {
    await LoginPersistence.loadLogin(loginData);
    isUserLoggedIn = isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  bool isLoggedIn() {
    return loginData.email.isNotEmpty && loginData.password.isNotEmpty;
  }

  Future<void> loadProfileImage() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageData = _prefs.getString('profileImage');
    });
  }

  Future<void> _uploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final fileData = File(result.files.single.path!);
      final imageData = await fileData.readAsBytes();
      final base64ImageData = base64Encode(imageData);

      setState(() {
        _imageData = base64ImageData;
      });

      _prefs.setString('profileImage', base64ImageData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            // actions: <Widget>[
            //   popUpLogout(),
            // ],
            title: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Profile',
                          style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily)),
                    ),
                    popUpLogout(),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: _imageData != null
                          ? MemoryImage(base64Decode(_imageData!))
                          : AssetImage('assets/profile.jpg')
                              as ImageProvider<Object>?,
                      radius: 80,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            '${loginData.email}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Column(
                          children: [
                            SizedBox(height: 33),
                            Column(
                              children: [
                                Text('Workouts'),
                                SizedBox(
                                  height: 11,
                                ),
                                Text('123',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _uploadImage,
                        child: Text('Upload Image'),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 22,
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Workout Summary',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              'Streaks 2 Weeks ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              'Rest 1 Day',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey,
                        image: DecorationImage(
                            // fit: BoxFit.scaleDown,
                            opacity: 0.2,
                            image: AssetImage(
                                'assets/appIcon/android/play_store_512.png')),
                        // border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(22)),
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        selectedDayTextStyle: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            color: Colors.white),
                        dayTextStyle: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            color: Colors.white),
                        calendarType: CalendarDatePicker2Type.multi,
                      ),
                      value: _dates,
                      onValueChanged: (dates) => _dates = dates,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget popUpLogout() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.settings,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
            value: 'Logout',
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'Logout') {
          LoginPersistence.logOut();
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => SignIn(),
          //     ));
          SystemNavigator.pop();
          // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
        } else if (value == 'option2') {
          // Handle Option 2
        }
      },
      color: Colors.black54,
    );
  }
}
