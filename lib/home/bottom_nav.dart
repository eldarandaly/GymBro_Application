import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gymbro/bmi/calorie_page.dart';
import 'package:gymbro/profile/profile_page.dart';
// import 'package:gymbro/workoutpages/start_workout.dart';
// import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import '../feed/feedPage.dart';
import 'my_routine_page.dart';

class HomePage extends StatelessWidget {
  // final MyUser u;
  // const HomePage({Key? key, required this.u}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return WillPopScope(
      onWillPop: () async {
        // Return false to disable the back button functionality
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,

        // drawer: CustomDrawer(),
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => FeedPage(),
                  settings: settings,
                );
              },
            ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => WorkoutPage(),
                  settings: settings,
                );
              },
            ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage(),
                  settings: settings,
                );
              },
            ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => CaloriePage(),
                  settings: settings,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            iconSize: 33,
            selectedFontSize: 14,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(LineIcons.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(LineIcons.dumbbell), label: 'Workout'),
              const BottomNavigationBarItem(
                  icon: Icon(LineIcons.userCircle), label: 'Profile'),
              const BottomNavigationBarItem(
                  icon: Icon(LineIcons.calculator), label: 'Calories'),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}


// Column(

//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PredictPage()),
//                     );
//                   },
//                   child: const Text('check Heart')),
//               const SizedBox(width: 20.0),
//               ElevatedButton(
//                 child: const Text('Go to Heart Reading Page'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => HeartRateLineChart()),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 child: const Text('Enter Heart Data'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HeartReadingPage()),
//                   );
//                 },
//               ),
//               const SizedBox(width: 20.0),
//               ElevatedButton(
//                 child: const Text('Profile'),
//                 onPressed: () {
//                   globleE = u.email;
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ProfilePageClass(
//                               thisEmail: u.email,
//                             )),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),

