import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/charts/chart_activity_status.dart';
import 'package:gymbro/charts/chart_sleep.dart';
import 'package:gymbro/charts/chart_workout_progress.dart';
import 'package:gymbro/charts/latest_workout.dart';
import 'package:gymbro/charts/theme/colors.dart';
import 'package:gymbro/constants.dart';
import 'package:gymbro/data_base/add_exercises.dart';
import 'package:gymbro/data_base/local_api.dart';
import 'package:gymbro/size_config.dart';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../charts/water_intake_progressbar.dart';
import '../charts/water_intake_timeline.dart';
import '../workoutpages/prev_workout.dart';

class WorkoutPage extends StatefulWidget {
  // final List<String> selectedExeList;
  // WorkoutPage({required this.selectedExeList});
  // @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  Map<String?, dynamic> exercisesImages = Exercise.images;

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
    // Provider.of<WorkoutDataProvider>(context, listen: false)
    //     .loadWorkoutDatabase();
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

  void showRenameRoutineDialog(BuildContext _context, int index) {
    String routineName = '';
    bool showError = false;

    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Rename Routine',
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
                      hintText: 'Rename Routine Name',
                      errorText: showError && routineName.isEmpty
                          ? 'Enter Routine Name'
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showError = true;

                        if (routineName.isNotEmpty) {
                          setState(() {
                            routines[index][0] = routineName;
                            Navigator.pop(context);
                          });
                          // Close the dialog
                        }
                      });
                    },
                    child: Text('Rename'),
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
          child: homePageLayout(context),
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

  Column homePageLayout(BuildContext context) {
    return Column(
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
                                    fontFamily: GoogleFonts.asap().fontFamily)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontFamily: GoogleFonts.asap().fontFamily)),
                            editDeletePop(index, context),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int itemIndex) {
                              // final imagesGifs = Exercise.images;
                              // final _exerciseName = routines[index][1]
                              //         [itemIndex]
                              //     ?.replaceAll(RegExp(r'[\/\s]'), '_');

                              // final exerciseGif =
                              //     imagesGifs[_exerciseName];
                              return ListTile(
                                title: Row(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
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
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily:
                                                GoogleFonts.asap().fontFamily,
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
                              List<String>? selectedExercises = selectedData[0];
                              List<String>? selectedGifs = selectedData[1];

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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add Execrsie",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily,
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
      ], //222
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
          // const PopupMenuItem<String>(
          //   value: 'Rename',
          //   child: Text(
          //     'Rename',
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
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
        // else if (value == 'Rename') {
        //   setState(() {
        //     showRenameRoutineDialog(context, index);
        //   });
        // }
      },
      color: Colors.white,
    );
  }

  Widget getBody(BuildContext context) {
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
                                    style:
                                        TextStyle(fontSize: 13, color: white),
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                                          shape: BoxShape.circle,
                                          color: primary),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                  Text(
                    "See more",
                    style:
                        TextStyle(fontSize: 15, color: white.withOpacity(0.5)),
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
}
