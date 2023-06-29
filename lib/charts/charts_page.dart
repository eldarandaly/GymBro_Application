import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/charts/chart_activity_status.dart';
import 'package:gymbro/charts/chart_sleep.dart';
import 'package:gymbro/charts/chart_workout_progress.dart';
import 'package:gymbro/charts/latest_workout.dart';
import 'package:gymbro/charts/theme/colors.dart';
import 'package:gymbro/charts/water_intake_progressbar.dart';
import 'package:gymbro/charts/water_intake_timeline.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Body(context),
    );
  }
}

Widget Body(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return SingleChildScrollView(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(fontSize: 14, color: white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Eldarandaly",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Icon(LineIcons.bell),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 145,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(colors: [secondary, primary]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: (size.width),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "BMI (Body Mass Index)",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                            ),
                            Text(
                              "You have a normal weight",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: black),
                            ),
                            Container(
                              width: 95,
                              height: 35,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [fourthColor, thirdColor]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  "View More",
                                  style: TextStyle(fontSize: 13, color: white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            LinearGradient(colors: [fourthColor, thirdColor]),
                      ),
                      child: Center(
                        child: Text(
                          "20.3",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today Target",
                      style: TextStyle(
                          fontSize: 17,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/");
                      },
                      child: Container(
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [secondary, primary]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Check",
                            style: TextStyle(fontSize: 13, color: white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Activity Status",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: white),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  color: secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30)),
              child: Stack(
                children: [
                  Container(
                    // color: white,
                    width: double.infinity,
                    child: activityData(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Heart Rate",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  width: (size.width - 80) / 2,
                  height: 320,
                  decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.01),
                            spreadRadius: 20,
                            blurRadius: 10,
                            offset: Offset(0, 10))
                      ],
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        WateIntakeProgressBar(),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                "Water Intake",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "Real time updates",
                                    style:
                                        TextStyle(fontSize: 13, color: black),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  WaterIntakeTimeLine()
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: (size.width - 80) / 2,
                        height: 150,
                        decoration: BoxDecoration(
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                  color: black.withOpacity(0.01),
                                  spreadRadius: 20,
                                  blurRadius: 10,
                                  offset: Offset(0, 10))
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sleep",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                              ),
                              Spacer(),
                              Flexible(
                                child: LineChart(sleepData()),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: (size.width - 80) / 2,
                          height: 150,
                          decoration: BoxDecoration(
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                    color: black.withOpacity(0.01),
                                    spreadRadius: 20,
                                    blurRadius: 10,
                                    offset: Offset(0, 10))
                              ],
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Calories",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: black)),
                                Spacer(),
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          colors: [
                                            fourthColor,
                                            primary.withOpacity(0.5)
                                          ]),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: primary),
                                    child: Center(
                                      child: Text(
                                        "1900 Cal",
                                        style: TextStyle(
                                            fontSize: 12, color: white),
                                      ),
                                    ),
                                  )),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Workout Progress",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: white),
                ),
                Container(
                  width: 95,
                  height: 35,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [secondary, primary]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Weekly",
                        style: TextStyle(fontSize: 13, color: white),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: white,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                  color: white,
                  boxShadow: [
                    BoxShadow(
                        color: black.withOpacity(0.01),
                        spreadRadius: 20,
                        blurRadius: 10,
                        offset: Offset(0, 10))
                  ],
                  borderRadius: BorderRadius.circular(30)),
              child: workoutProgressData(),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Latest Workout",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: white),
                ),
                Text(
                  "See more",
                  style: TextStyle(fontSize: 15, color: white.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(latestWorkoutJson.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.01),
                              spreadRadius: 20,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        latestWorkoutJson[index]['img']))),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Container(
                              height: 55,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    latestWorkoutJson[index]['title'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: black),
                                  ),
                                  Text(
                                    latestWorkoutJson[index]['description'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: black.withOpacity(0.5)),
                                  ),
                                  Stack(children: [
                                    Container(
                                      width: size.width,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: bgTextField),
                                    ),
                                    Container(
                                      width: size.width *
                                          (latestWorkoutJson[index]
                                              ['progressBar']),
                                      height: 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                              colors: [primary, secondary])),
                                    )
                                  ])
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primary)),
                            child: Center(
                              child: Icon(Icons.arrow_forward_ios,
                                  size: 11, color: primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    ),
  );
}

class celanderPage extends StatefulWidget {
  const celanderPage({super.key});

  @override
  State<celanderPage> createState() => _celanderPageState();
}

class _celanderPageState extends State<celanderPage> {
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

// TODO: design the page to have the calendaer in the midel with workoit days and rest days
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  // color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'Streaks ${_dates.length} days 🔥',
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
                        'Rest 1 Day 🌙',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey,
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          opacity: 0.2,
                          image: AssetImage(
                              'assets/appIcon/android/play_store_512.png'),
                        ),
                        // border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(22)),
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        dayBuilder: ({
                          required date,
                          textStyle,
                          decoration,
                          isSelected,
                          isDisabled,
                          isToday,
                        }) {
                          Widget? dayWidget;
                          if (isSelected == true) {
                            dayWidget = Container(
                              decoration: decoration,
                              child: Center(
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(
                                      MaterialLocalizations.of(context)
                                          .formatDecimal(date.day),
                                      style: textStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 27.5),
                                      child: Container(
                                        height: 4,
                                        width: 4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: isSelected == true
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return dayWidget;
                        },
                        weekdayLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        weekdayLabels: [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat'
                        ],
                        firstDayOfWeek: 1,
                        centerAlignModePicker: true,
                        customModePickerIcon: SizedBox(),
                        selectedDayTextStyle: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            color: Colors.white,
                            // decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                        selectedDayHighlightColor: Colors.blue[800],
                        dayTextStyle: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            color: Colors.white),
                        calendarType: CalendarDatePicker2Type.multi,
                      ),
                      value: _dates,
                      // onValueChanged: (dates) => _dates = dates,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
