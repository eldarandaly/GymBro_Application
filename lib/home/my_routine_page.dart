// import 'package:flutter/material.dart';

// import '../workoutpages/prev_workout.dart';

// void main() {
//   runApp(WorkoutApp());
// }

// class WorkoutApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Workout App',
//       home: WorkoutPage(),
//       theme: ThemeData.dark(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class WorkoutPage extends StatefulWidget {
//   @override
//   _WorkoutPageState createState() => _WorkoutPageState();
// }

// class _WorkoutPageState extends State<WorkoutPage> {
//   int counter = 1;
//   String titleRotName = '';
//   List<List<String>> routines = [
//     [
//       'Day 1',
//       'Cable Fly CrossOver',
//       'Incline Chest Press',
//       'Bicep Curl',
//       'Triceps Pushdown'
//     ],
//   ];

//   void generateRoutines(int count) {
//     for (int i = 1; i <= count; i++) {
//       List<String> newRoutine = [
//         'Day ${counter + count}',
//         'Cable Fly CrossOver',
//         'Incline Chest Press',
//         'Bicep Curl',
//         'Triceps Pushdown'
//       ];
//       routines.add(newRoutine.toList());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Workout Routines'),
//       ),
//       body: ListView.builder(
//         itemCount: routines.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Column(
//             children: [
//               Divider(),
//               Card(
//                 elevation: 10,
//                 child: ListTile(
//                   title: Text(
//                     routines[index][0],
//                     style: TextStyle(fontSize: 22),
//                   ), // Routine name
//                   subtitle: Text(
//                       'Items: ${routines[index].sublist(1).join(', ')}'), // Items a, b, c
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PrevWorkout(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         splashColor: Colors.blue,
//         onPressed: () {
//           generateRoutines(1);
//           counter++;
//           // setState(() {}); // Update the UI to reflect the new routines
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// import '../workoutpages/prev_workout.dart';

// void main() {
//   runApp(WorkoutApp());
// }

// class WorkoutApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Workout App',
//       home: WorkoutPage(),
//       theme: ThemeData.dark(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class WorkoutPage extends StatefulWidget {
//   @override
//   _WorkoutPageState createState() => _WorkoutPageState();
// }

// class _WorkoutPageState extends State<WorkoutPage> {
//   int counter = 1;
//   String titleRotName = '';
//   List<List<String>> routines = [
//     [
//       'Day 1',
//       'Cable Fly CrossOver',
//       'Incline Chest Press',
//       'Bicep Curl',
//       'Triceps Pushdown'
//     ],
//   ];

//   void generateRoutines(int count) {
//     for (int i = 1; i <= count; i++) {
//       List<String> newRoutine = [
//         'Day ${counter + count}',
//         'Cable Fly CrossOver',
//         'Incline Chest Press',
//         'Bicep Curl',
//         'Triceps Pushdown'
//       ];
//       routines.add(newRoutine.toList());
//     }
//   }

//   void addRoutine(String routineName) {
//     List<String> newRoutine = [
//       routineName,
//       'Exercise 1',
//       'Exercise 2',
//       'Exercise 3',
//       'Exercise 4',
//     ];
//     routines.add(newRoutine.toList());
//     setState(() {}); // Update the UI to reflect the new routine
//   }

//   void deleteRoutine(int index) {
//     setState(() {
//       routines.removeAt(index); // Remove the routine at the given index
//     });
//   }

//   void showAddRoutineDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String routineName = '';
//         return AlertDialog(
//           title: Text('Add Routine'),
//           content: TextField(
//             onChanged: (value) {
//               routineName = value;
//             },
//             decoration: InputDecoration(
//               hintText: 'Enter routine name',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 addRoutine(routineName);
//                 counter++;
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Workout Routines'),
//       ),
//       body: ListView.builder(
//         itemCount: routines.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Column(
//             children: [
//               Divider(),
//               Dismissible(
//                 key: Key(routines[index][0]),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Icon(
//                     Icons.delete,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onDismissed: (direction) {
//                   deleteRoutine(index);
//                 },
//                 child: Card(
//                   elevation: 10,
//                   child: ListTile(
//                     title: Text(
//                       routines[index][0],
//                       style: TextStyle(fontSize: 22),
//                     ), // Routine name
//                     subtitle: Text(
//                         'Items: ${routines[index].sublist(1).join(', ')}'), // Items a, b, c
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PrevWorkout(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         splashColor: Colors.blue,
//         onPressed: showAddRoutineDialog,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/constants.dart';
import 'package:gymbro/data_base/api_page.dart';
import 'package:gymbro/data_base/local_api.dart';
import 'package:gymbro/home/bottom_nav.dart';
import 'package:gymbro/size_config.dart';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../workoutpages/prev_workout.dart';
import 'package:http/http.dart' as http;

class WorkoutPage extends StatefulWidget {
  // final List<String> selectedExeList;
  // WorkoutPage({required this.selectedExeList});
  // @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<dynamic> exercises = [];
  int counter = 1;
  String titleRotName = '';
  List<List<dynamic>> gifsList = [
    [
      'Day 1',
      [
        'Cable Fly CrossOver',
        'Incline Chest Press',
        'Bicep Curl',
        'Triceps Pushdown'
      ]
    ],
  ];
  List<List<dynamic>> routines = [
    [
      'Day 1',
      [
        'Cable Fly CrossOver',
        'Incline Chest Press',
        'Bicep Curl',
        'Triceps Pushdown'
      ]
    ],
  ];
  @override
  void initState() {
    super.initState();
    // Load routines from shared preferences when the app is opened
    loadRoutines();
    Exercise.loadExerciseData();
    // fetchExercises();
  }

  void loadRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRoutines = prefs.getStringList('routines');
    List<String>? savedGifsList = prefs.getStringList('gifsList');

    if (savedRoutines != null && savedGifsList != null) {
      setState(() {
        routines = savedRoutines
            .map((routine) => routine.split(';'))
            .map((splitRoutine) => [
                  splitRoutine[0],
                  splitRoutine.sublist(1),
                ])
            .toList();
        gifsList = savedGifsList
            .map((routine) => routine.split(';'))
            .map((splitRoutine) => [
                  splitRoutine[0],
                  splitRoutine.sublist(1),
                ])
            .toList();

        // gifsList = savedGifsList.toList();
      });
    }
  }

  // Inside the Stateful Widget class
  void showEditPopup(BuildContext context, int index) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> items = List<String>.from(routines[index][1]);
          List<bool> selectedItems = List<bool>.filled(items.length, false);

          return AlertDialog(
            title: Text('Edit Routine'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return CheckboxListTile(
                            title: Text(items[itemIndex]),
                            value: selectedItems[itemIndex],
                            onChanged: (bool? value) {
                              if (value != null) {
                                setState(() {
                                  selectedItems[itemIndex] = value;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  List<int> indexesToRemove = [];

                  for (int i = 0; i < selectedItems.length; i++) {
                    if (selectedItems[i]) {
                      indexesToRemove.add(i);
                    }
                  }

                  // Remove selected items from the list
                  for (int i = indexesToRemove.length - 1; i >= 0; i--) {
                    int itemIndex = indexesToRemove[i];
                    // routines[index][1].removeAt(itemIndex);
                    deleteExercise(index, itemIndex);
                  }

                  Navigator.of(context).pop();
                },
                child: Text('Delete Selected'),
              ),
            ],
          );
        },
      );
    });
  }

  void saveRoutines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedRoutines = routines
        .map((routine) => '${routine[0]};${routine[1].join(';')}')
        .toList();
    List<String> _gifsList = gifsList
        .map((routine) => '${routine[0]};${routine[1].join(';')}')
        .toList();
    await prefs.setStringList('routines', savedRoutines);
    await prefs.setStringList('gifsList', _gifsList);
  }

  void addRoutine(String routineName) {
    List<dynamic> newRoutine = [
      routineName,
      [],
    ];
    List<Object> typedRoutine = List<Object>.from(newRoutine);
    routines.add(typedRoutine);
    List<dynamic> newGifs = [
      'routineName',
      [],
    ];
    List<Object> typedGifs = List<Object>.from(newGifs);
    gifsList.add(typedGifs);
    setState(() {
      saveRoutines(); // Save the updated routines
    }); // Update the UI to reflect the new routine
  }

  void addItem(int routineIndex, String itemName) {
    setState(() {
      routines[routineIndex][1]
          .add(itemName); // Add the item to the specific routine
      saveRoutines(); // Save the updated routines
    });
  }

  void addGifs(int routineIndex, String itemName) {
    setState(() {
      // final exercise = exercises;
      // final exerciseGif = exercise['gifUrl'] as String;
      gifsList[routineIndex][1]
          .add(itemName); // Add the item to the specific routine
      saveRoutines(); // Save the updated routines
    });
  }

  Future<void> deleteRoutine(int index) async {
    setState(() {
      routines.removeAt(index);
      gifsList.removeAt(index);
      // Remove the routine at the given index
      saveRoutines(); // Save the updated routines
    });
  }

  Future<void> deleteGifsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gifsList', []);
  }

  void deleteExercise(int index, int itemIndex) {
    setState(() {
      routines[index][1].removeAt(itemIndex);
      saveRoutines(); // Save the updated routines
    });
  }

  void showAddRoutineDialog() {
    String routineName = '';
    bool showError = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Routine',
            style: TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        routineName = value;
                        showError = false;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter routine name',
                      errorText: showError && routineName.isEmpty
                          ? 'Enter routine name'
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showError = true;
                      });
                      if (routineName.isNotEmpty) {
                        addRoutine(routineName);
                        counter++;
                        Navigator.pop(context); // Close the dialog
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showAddItemDialog() {
    String itemName = '';
    bool showError = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        itemName = value;
                        showError = false;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter item name',
                      errorText: showError && itemName.isEmpty
                          ? 'Enter item name'
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showError = true;
                      });
                      if (itemName.isNotEmpty) {
                        // addItem(itemName);
                        Navigator.pop(context); // Close the dialog
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text('Workout Routines',
                      style:
                          TextStyle(fontFamily: GoogleFonts.asap().fontFamily)),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Esay Start',
                      style: headingStyle,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  child: Card(
                    // color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Set the desired border radius
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartWorkoutPage(
                              gifsList: [],
                              rotName: '',
                              routineItems: [],
                              isEmptyWorkout: true,
                            ),
                          ),
                        );
                      },
                      // tileColor: Colors.white30,
                      leading: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      title: Center(
                        child: Text(
                          'Start Empty Workout',
                          style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'My Routines',
                      style: TextStyle(
                          fontFamily: GoogleFonts.asap().fontFamily,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("About"),
                                  content: Text(
                                      "This Application is Developed by \n\n ElDarandaly",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: const Icon(Icons.favorite),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 160,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the desired border radius
                          ),
                          child: ListTile(
                            onTap: showAddRoutineDialog,
                            // tileColor: Colors.white30,
                            leading: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Add New Routine',
                              style: TextStyle(
                                  fontFamily: GoogleFonts.asap().fontFamily,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 160,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the desired border radius
                          ),
                          child: ListTile(
                            onTap: () {},
                            // tileColor: Colors.white30,
                            leading: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            title: Text(
                              'Explore',
                              style: TextStyle(
                                  fontFamily: GoogleFonts.asap().fontFamily,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: routines.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the desired border radius
                        ),
                        elevation: 10,
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.fitness_center_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(routines[index][0],
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily)),
                                  editDeletePop(index, context),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int itemIndex) {
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.all(8.0),
                                          //   child: CircleAvatar(
                                          //     child: Text(
                                          //       '${itemIndex + 1}',
                                          //       style: TextStyle(
                                          //         color: Colors.black,
                                          //       ),
                                          //     ),
                                          //     backgroundColor: Colors.blue,
                                          //   ),
                                          // ),
                                          Flexible(
                                            child: Text(
                                              routines[index][1].join(','),
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: GoogleFonts.asap()
                                                      .fontFamily,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrevWorkout(
                                      routine: routines[index],
                                      glifsList: gifsList[index][1],
                                    ),
                                  ),
                                );
                              },
                            ),
                            CupertinoButton(
                                padding: EdgeInsets.all(1),
                                onPressed: () async {
                                  List<List<String>>? selectedData =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApiClass(),
                                    ),
                                  );

                                  if (selectedData != null) {
                                    List<String>? selectedExercises =
                                        selectedData[0];
                                    List<String>? selectedGifs =
                                        selectedData[1];

                                    if (selectedExercises != null &&
                                        selectedExercises.isNotEmpty) {
                                      // Do something with the selected exercises
                                      // For example, add them to the workout routines
                                      selectedExercises.forEach(
                                        (exercise) {
                                          addItem(index, exercise);
                                        },
                                      );
                                      if (selectedGifs != null &&
                                          selectedGifs.isNotEmpty) {
                                        // Do something with the selected exercises
                                        // For example, add them to the workout routines
                                        selectedGifs.forEach(
                                          (gifs) {
                                            addGifs(index, gifs);
                                          },
                                        );
                                      }
                                    }
                                  }
                                },
                                // child: ListTile(
                                //   trailing: Icon(
                                //     Icons.add,
                                //     color: Colors.blue,
                                //   ),
                                // ),
                                child: SizedBox(
                                  width: SizeConfig.screenWidth / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Add Execrsie",
                                            style: TextStyle(
                                                fontFamily: GoogleFonts.asap()
                                                    .fontFamily,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   splashColor: Color.fromARGB(255, 33, 150, 243),
        //   onPressed: showAddRoutineDialog,
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }

  PopupMenuButton<String> editDeletePop(int index, BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.blue,
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Delete',
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Edit',
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'Delete') {
          setState(() {
            deleteRoutine(index);
          });
        } else if (value == 'Edit') {
          setState(() {
            showEditPopup(context, index);
          });
        }
      },
      color: Colors.white,
    );
  }
}
