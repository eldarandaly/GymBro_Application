import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymbro/ai_planer/work_out_plan.dart';

import 'package:gymbro/bmi/calorie_page.dart';
import 'package:gymbro/profile/profile_page.dart';

import 'package:line_icons/line_icons.dart';
import 'package:mdi/mdi.dart';

import '../feed/feedPage.dart';
import 'home_page.dart';

class HomePage extends StatelessWidget {
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
        drawer: Drawer(),
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
            // Navigator(
            //   onGenerateRoute: (RouteSettings settings) {
            //     return MaterialPageRoute(
            //       builder: (BuildContext context) => WorkoutPlanForm(),
            //       settings: settings,
            //     );
            //   },
            // ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => WorkoutPage(),
                  settings: settings,
                );
              },
            ),
            // Navigator(
            //   onGenerateRoute: (RouteSettings settings) {
            //     return MaterialPageRoute(
            //       builder: (BuildContext context) => CaloriePage(),
            //       settings: settings,
            //     );
            //   },
            // ),
            Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage(),
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
                  icon: Icon(Mdi.home), label: 'Home'),
              // const BottomNavigationBarItem(
              //     icon: Icon(Mdi.robot), label: 'Planner'),
              const BottomNavigationBarItem(
                  icon: Icon(Mdi.dumbbell), label: 'Workout'),
              // const BottomNavigationBarItem(
              //     icon: Icon(Mdi.calculator), label: 'Calories'),
              const BottomNavigationBarItem(
                  icon: Icon(Mdi.face), label: 'Profile'),
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
