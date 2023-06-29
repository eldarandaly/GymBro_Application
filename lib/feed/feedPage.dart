import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/MuscleGroupSelector/muscle_group_selector.dart';
import 'package:gymbro/size_config.dart';
import 'package:gymbro/splash/components/default_button.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../workoutpages/start_workout.dart';

// class FeedPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<WorkoutData> workoutData =
//         Provider.of<WorkoutDataProvider>(context).workoutData;
//     DateTime now = DateTime.now();
//     String date = DateFormat('yyyy-MM-dd').format(now);
//     String time = DateFormat('HH:mm').format(now);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed'),
//       ),
//       body: ListView.builder(
//         itemCount: workoutData.length,
//         itemBuilder: (context, index) {
//           WorkoutData workout = workoutData[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Workout Date: $date',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Workout Time: $time',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: workout.data.length,
//                     itemBuilder: (context, dataIndex) {
//                       final data = workout.data[dataIndex];
//                       return ListTile(
//                         title: Text('Exercise: ${workoutData[index].exercise}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Set: ${data['set']}'),
//                             Text('Weight: ${data['weight']}'),
//                             Text('Reps: ${data['reps']}'),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class FeedPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<WorkoutData> workoutData =
//         Provider.of<WorkoutDataProvider>(context).workoutData;
//     DateTime now = DateTime.now();
//     String date = DateFormat('yyyy-MM-dd').format(now);
//     String time = DateFormat('HH:mm').format(now);

//     int workoutCounter =
//         Provider.of<WorkoutDataProvider>(context).workoutCounter;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed'),
//       ),
//       body: ListView.builder(
//         itemCount: workoutData.length,
//         itemBuilder: (context, index) {
//           WorkoutData workout = workoutData[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Workout Date: $date',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Workout Time: $time',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Workout Counter: $workoutCounter',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: workout.data.length,
//                     itemBuilder: (context, dataIndex) {
//                       final data = workout.data[dataIndex];
//                       return ListTile(
//                         title: Text('Exercise: ${workoutData[index].exercise}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Set: ${data['set']}'),
//                             Text('Weight: ${data['weight']}'),
//                             Text('Reps: ${data['reps']}'),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class FeedPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<WorkoutData> workoutData =
//         Provider.of<WorkoutDataProvider>(context).workoutData;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed'),
//       ),
//       body: ListView(
//         children: workoutData.map((workout) {
//           DateTime now = DateTime.now();
//           String date = DateFormat('yyyy-MM-dd').format(now);
//           String time = DateFormat('HH:mm').format(now);

//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Workout Date: $date',
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Workout Time: $time',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Workout Counter: ${Provider.of<WorkoutDataProvider>(context).workoutCounter}',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: workout.data.map((data) {
//                         return ListTile(
//                           title: Text('Exercise: ${workout.exercise}'),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Set: ${data['set']}'),
//                               Text('Weight: ${data['weight']}'),
//                               Text('Reps: ${data['reps']}'),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class FeedPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<WorkoutData> workoutData =
//         Provider.of<WorkoutDataProvider>(context).workoutData;
//     DateTime now = DateTime.now();
//     String date = DateFormat('EEE, M/d/y').format(now);
//     String time = DateFormat('HH:mm').format(now);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feed'),
//       ),
//       body: ListView(
//         children: workoutData.map((workout) {
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WorkoutDetailsPage(workout: workout),
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Workout Date: $date',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Workout Time: $time',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class WorkoutDetailsPage extends StatelessWidget {
//   final WorkoutData workout;

//   const WorkoutDetailsPage({required this.workout});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Workout Details'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Exercise: ${workout.exercise}',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: workout.data.length,
//               itemBuilder: (context, index) {
//                 final data = workout.data[index];
//                 return ListTile(
//                   title: Text('Set: ${data['set']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Weight: ${data['weight']}'),
//                       Text('Reps: ${data['reps']}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<WorkoutSession> workoutSessions = [];

  @override
  void initState() {
    super.initState();
    // Load the saved workout data when the page is initialized
    loadSavedWorkoutData();
    saveWorkoutData();
  }

  @override
  void dispose() {
    // Save the workout data before the page is disposed
    saveWorkoutData();
    super.dispose();
  }

  void loadSavedWorkoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? workoutSessionsJsonList =
        prefs.getStringList('workoutSessions');

    if (workoutSessionsJsonList != null) {
      // Convert the JSON string back to workout data
      setState(() {
        workoutSessions = workoutSessionsJsonList
            .map((json) => WorkoutSession.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  void deleteRoutine(int index) {
    setState(() {
      workoutSessions.removeAt(index); // Remove the routine at the given index
      saveWorkoutData(); // Save the updated routines
    });
  }

  Future<void> saveWorkoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert workout sessions to JSON strings
    List<String> workoutSessionsJsonList = workoutSessions
        .map((workoutSession) => jsonEncode(workoutSession.toJson()))
        .toList();
    // Save workout sessions to SharedPreferences
    await prefs.setStringList('workoutSessions', workoutSessionsJsonList);
  }

  @override
  Widget build(BuildContext context) {
    workoutSessions = Provider.of<WorkoutDataProvider>(context).workoutSessions;

    if (workoutSessions.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              title: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No Workouts Done Bro Come on !!',
                        style: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily)),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      color: Colors.white24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text('No Workouts Done Yet Lets Do one',
                          style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 22,
                              color: Colors.white))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
        ),
        body: ListView.builder(
          itemCount: workoutSessions.length,
          itemBuilder: (context, index) {
            WorkoutSession workoutSession =
                workoutSessions.reversed.toList()[index];

            // WorkoutSession workoutSession = workoutSessions[index];
            DateTime dateTime = workoutSession.dateTime;
            String date = DateFormat('yyyy-MM-dd').format(dateTime);
            String time = DateFormat('HH:mm').format(dateTime);
            String titleroe = workoutSession.titleRot;
            String imagePath = workoutSession.imagePath; // Get the imagePath
            // saveWorkoutData();

            return GestureDetector(
              onTap: () {
                // Navigate to the workout details screen passing the workout session
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailsPage(
                      workoutSession: workoutSession,
                    ),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              LineIcons.dumbbell,
                              color: Colors.white,
                            ),
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$titleroe',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.asap().fontFamily),
                              ),
                              Text(
                                'Workout Date: $date',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.asap().fontFamily),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Workout Time: $time',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.asap().fontFamily),
                              ),
                            ],
                          ),
                          Spacer(),
                          PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  value: 'option1',
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              if (value == 'option1') {
                                deleteRoutine(index);
                              } else if (value == 'option2') {
                                // Handle Option 2
                              }
                            },
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      if (imagePath != null && imagePath.isNotEmpty)
                        Image.memory(
                          base64Decode(imagePath),
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      // if (imagePath == null || imagePath.isEmpty)
                      Container(
                        color: Colors.white,
                        child: Container(
                            color: Colors.red,
                            width: SizeConfig.screenWidth,
                            height: 300,
                            child: MuscleGroupSelector(
                              workoutSession: workoutSession,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle like button pressed
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                size: 18,
                              ),
                              label: Text('Like'),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle comment button pressed
                              },
                              icon: Icon(
                                Icons.comment,
                                size: 18,
                              ),
                              label: Text('Comment'),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle share button pressed
                              },
                              icon: Icon(
                                Icons.share,
                                size: 18,
                              ),
                              label: Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutSession workoutSession;
  WorkoutDetailsPage({required this.workoutSession});

  @override
  Widget build(BuildContext context) {
    // Access the workout session data
    DateTime dateTime = workoutSession.dateTime;
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    String time = DateFormat('HH:mm').format(dateTime);
    List<WorkoutData> workoutData = workoutSession.workoutData;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Workout Details',
            style: TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Date: $date',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.asap().fontFamily),
              ),
              SizedBox(height: 8.0),
              Text(
                'Workout Time: $time',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.asap().fontFamily),
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workoutData.length,
                itemBuilder: (context, index) {
                  WorkoutData workout = workoutData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exercise: ${workout.exercise}',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.asap().fontFamily),
                          ),
                          SizedBox(height: 8.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: workout.data.length,
                            itemBuilder: (context, dataIndex) {
                              final data = workout.data[dataIndex];
                              return ListTile(
                                title: Text('Set: ${data['set']}',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.asap().fontFamily)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Weight: ${data['weight']}',
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.asap().fontFamily)),
                                    Text('Reps: ${data['reps']}',
                                        style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.asap().fontFamily)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
