import 'dart:convert';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:gymbro/constants.dart';
import 'package:gymbro/data_base/api_page.dart';
import 'package:gymbro/data_base/local_api.dart';
import 'package:gymbro/data_base/sqfLite.dart';
import 'package:gymbro/home/bottom_nav.dart';
// import 'package:gymbro/home/my_routine_page.dart';
import 'package:gymbro/size_config.dart';
import 'package:gymbro/workoutpages/finish_workout.dart';
import 'package:gymbro/workoutpages/reorder_page.dart';
// import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mdi/mdi.dart';

// import '../feed/feedPage.dart';

class WorkoutSession {
  DateTime dateTime;
  List<WorkoutData> workoutData;
  String titleRot;
  String imagePath;
  WorkoutSession(
      {required this.dateTime,
      required this.workoutData,
      required this.titleRot,
      required this.imagePath});

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    List<dynamic> workoutDataJsonList = json['workoutData'];
    List<WorkoutData> workoutData = [];

    if (workoutDataJsonList != null && workoutDataJsonList.isNotEmpty) {
      workoutData = workoutDataJsonList
          .map((json) => WorkoutData.fromJson(json))
          .toList();
    }

    String titleRots = workoutData.isNotEmpty ? workoutData[0].titlename : '';

    return WorkoutSession(
      dateTime: DateTime.parse(json['dateTime']),
      workoutData: workoutData,
      titleRot: titleRots,
      imagePath: json['imagePath'], // Add imagePath property
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> workoutDataJsonList =
        workoutData.map((workout) => workout.toJson()).toList();

    return {
      'dateTime': dateTime.toIso8601String(),
      'workoutData': workoutDataJsonList,
      'imagePath': imagePath,
    };
  }
}

class WorkoutData {
  final String exercise;
  final List<Map<String, dynamic>> data;
  final int counter;
  final String titlename;
  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
        // Parse the JSON object and extract the necessary fields
        exercise: json['exercise'],
        data: List<Map<String, dynamic>>.from(json['data']),
        counter: 0,
        titlename: json['titlerot']);
  }
  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise,
      'data': data,
      'counter': counter,
      'titlerot': titlename,
    };
  }

  WorkoutData({
    required this.exercise,
    required this.data,
    required this.counter,
    required this.titlename,
  });
}

class WorkoutDataProvider extends ChangeNotifier {
  List<WorkoutData> _workoutData = [];
  int workoutCounter = 0;
  List<WorkoutSession> workoutSessions = [];
  late List<DateTime?> _dates = [];

  List<WorkoutData> get workoutData => _workoutData;
  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addWorkoutData(List<WorkoutData> workoutData, DateTime dateTime,
      String titleRot1, String imageOfWk) async {
    final workoutSession = WorkoutSession(
        dateTime: dateTime,
        workoutData: workoutData,
        titleRot: titleRot1,
        imagePath: imageOfWk);

    // Save DateTime using SharedPreferences
  }

  void removeWorkoutData(WorkoutData workout) {
    _workoutData.remove(workout);
    notifyListeners();
  }

  void incrementWorkoutCounter() {
    workoutCounter++;
    notifyListeners();
  }

  Future<void> addWorkoutSession(WorkoutSession workoutSession) async {
    workoutSessions.add(workoutSession);
    notifyListeners();
    bool sessionInserted =
        await _databaseHelper.insertWorkoutSession(workoutSession);
    bool dataInserted = true;

    if (sessionInserted) {
      int sessionId = await _databaseHelper.getLastInsertedSessionId();
      for (WorkoutData data in workoutSession.workoutData) {
        Map<String, dynamic> jsonData = data.toJson();
        int inserted =
            await _databaseHelper.insertWorkoutData(sessionId, jsonData);
        if (inserted == -1) {
          dataInserted = false;
          break;
        }
      }
    } else {
      dataInserted = false;
    }

    if (sessionInserted && dataInserted) {
      workoutSessions.add(workoutSession);
      notifyListeners();
      print('Data inserted successfully');
    } else {
      print('Failed to insert data into the database');
    }
    await saveDateTime(workoutSession.dateTime);
  }

  Future<void> saveDateTime(DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dates.add(dateTime);

    List<String> dateTimeStrings = _dates.map((dateTime) {
      return dateTime!.toIso8601String();
    }).toList();

    await prefs.setStringList('workoutDates', dateTimeStrings);
    notifyListeners();
  }

  void saveWorkoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> workoutSessionsJsonList = workoutSessions
        .map((workoutSession) => jsonEncode(workoutSession.toJson()))
        .toList();
    await prefs.setStringList('workoutSessions', workoutSessionsJsonList);
  }

  void loadWorkoutData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? workoutSessionsJsonList =
        prefs.getStringList('workoutSessions');

    if (workoutSessionsJsonList != null) {
      workoutSessions = workoutSessionsJsonList
          .map((json) => WorkoutSession.fromJson(jsonDecode(json)))
          .toList();
    }
    notifyListeners(); // Notify listeners of the data change
  }
}

// ignore: must_be_immutable
class StartWorkoutPage extends StatefulWidget {
  final List<dynamic> routineItems;
  final String rotName;
  final List<dynamic> gifsList;
  bool? isEmptyWorkout = false;
  StartWorkoutPage(
      {required this.routineItems,
      required this.rotName,
      required this.gifsList,
      required this.isEmptyWorkout});

  @override
  _StartWorkoutPageState createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  List<List<DataRow>> _exerciseRows = [];
  List<List<dynamic>> _exerciseCounters = [];
  List<List<bool>> _selectedRows = [];
  String name = '';
  Color _iconColor = Colors.white;
  bool _onTap = false;

  List<String> exercises = [];
  late String exName = '';
  int _totalSets = 0;
  int _totalWeight = 0;
  List<dynamic> gifsListExe = [];
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = '00:00:00';
  final fieldText = TextEditingController();
  Map<String?, dynamic> exercisesImages = Exercise.images;
  @override
  void initState() {
    super.initState();
    exercises =
        List<String>.from(widget.routineItems); // Flatten the nested list
    exName = widget.rotName;
    if (gifsListExe.isEmpty) {
      gifsListExe = List<dynamic>.from(widget.gifsList);
    }

    initializeExerciseRows();

    // Start the timer
    _startTimer();
  }

  void initializeExerciseRows() {
    for (int i = 0; i < exercises.length; i++) {
      _exerciseRows.add([]);
      _exerciseCounters.add([1]);
      _selectedRows.add([false]);
    }
  }

  void _deleteRow(int exerciseIndex, int rowIndex) {
    setState(() {
      _exerciseRows[exerciseIndex].removeAt(rowIndex);
      _selectedRows[exerciseIndex].removeAt(rowIndex);
      if (_exerciseRows[exerciseIndex].isEmpty) {
        _exerciseCounters[exerciseIndex] = [1];
        _selectedRows[exerciseIndex] = [false];
      }
    });
  }

  void clearText() {
    fieldText.clear();
  }

  void addRow(int exerciseIndex) {
    setState(() {
      final TextEditingController weightController = TextEditingController();
      final TextEditingController repsController = TextEditingController();
      _exerciseCounters[exerciseIndex]
          .add(_exerciseCounters[exerciseIndex].last + 1);
      _selectedRows[exerciseIndex].add(false); // Add initial value for new row

      _exerciseRows[exerciseIndex].add(
        DataRow(
          cells: [
            DataCell(Text('${_exerciseCounters[exerciseIndex].last}')),
            DataCell(TextField(
              controller: weightController,
              decoration: const InputDecoration.collapsed(hintText: 'KG'),
              keyboardType: TextInputType.number,
            )),
            DataCell(TextField(
              controller: repsController,
              decoration: const InputDecoration.collapsed(hintText: 'Reps'),
              keyboardType: TextInputType.number,
            )),
            DataCell(Checkbox(
              value: _selectedRows[exerciseIndex]
                  [_exerciseCounters[exerciseIndex].length - 1],
              onChanged: (value) {
                setState(() {
                  _selectedRows[exerciseIndex]
                      [_exerciseCounters[exerciseIndex].length - 1] = value!;
                });
              },
            )),
            // const DataCell(Icon(Icons.delete)),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = _formatElapsedTime(_stopwatch.elapsed);
      });
    });
  }

  // void _openGif(ImageProvider<Object> gifUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Image(image: gifUrl),
  //       );
  //     },
  //   );
  // }
  void _openGif(List<ImageProvider<Object>> gifUrls) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Unfocus any active text fields
            FocusScope.of(context).unfocus();
          },
          child: Dialog(
            child: Container(
              width: 400,
              height: 400,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 3),
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  aspectRatio: 1.0,
                  viewportFraction: 1.0,
                  autoPlay: true,
                ),
                items: gifUrls
                    .map(
                      (gifUrl) => Container(
                        child: Image(
                          image: gifUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
  // void showAddNameDialog() {
  //   bool showError = false;

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Add Routine'),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   onChanged: (value) {
  //                     setState(() {
  //                       name = value;
  //                       showError = false;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                     hintText: 'Enter routine name',
  //                     errorText: showError && name.isEmpty
  //                         ? 'Enter routine name'
  //                         : null,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       showError = true;
  //                     });
  //                     if (name.isNotEmpty) {
  //                       Navigator.pop(context); // Close the dialog
  //                     }
  //                   },
  //                   child: Text('Finish'),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               _finishWorkout(context);
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  String _formatElapsedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void addItem(int routineIndex, String itemName) {
    setState(() {
      exercises.add(itemName); // Add the item to the specific routine
      // Save the updated routines
      initializeExerciseRows();
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index); // Remove the exercise from the list
    });
  }

  void addGifs(int routineIndex, String itemName) {
    setState(() {
      gifsListExe.add(itemName); // Add the item to the specific routine
      // Save the updated routines
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalReps = 0;
    _totalSets = 0;
    _totalWeight = 0;
    _exerciseRows.forEach((rows) {
      _totalSets += rows.length;

      rows.forEach((row) {
        final TextField weightField = row.cells[1].child as TextField;
        final TextEditingController weightController = weightField.controller!;
        final int? weight = int.tryParse(weightController.text);
        final TextField repsField = row.cells[2].child as TextField;
        final TextEditingController repsController = repsField.controller!;
        final int? reps = int.tryParse(repsController.text);
        if (weight != null && reps != null) {
          _totalWeight += weight * reps;
        }
      });
    });

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LetsGo'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _finishWorkout(context),
                        child: const Text('Finish'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ' $_elapsedTime',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        // Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Volume',
                          style: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$_totalWeight kg',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Sets',
                          style: TextStyle(
                            fontFamily: GoogleFonts.asap().fontFamily,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$_totalSets',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final exercise = exercises.removeAt(oldIndex);
                    exercises.insert(newIndex, exercise);
                  });
                },
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final imagesGifs = exercisesImages;

                  final _exerciseName =
                      exercises[index]?.replaceAll(RegExp(r'[\/\s]'), '_');

                  final exerciseGif = imagesGifs[_exerciseName];
                  return Card(
                    key: Key('$index'),
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: GestureDetector(
                                    onTap: () {
                                      _openGif(exerciseGif);
                                    },
                                    child: Image(
                                      image: exerciseGif[0],
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Image.asset(
                                          'assets/appIcon/android/play_store_512.png', // Path to your placeholder image
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      exercises[index],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context, index);
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Divider(),
                          tableView(index),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: ListTile(
                                    onTap: () => addRow(index),
                                    tileColor: Colors.white30,
                                    leading: const Icon(Icons.add),
                                    title: Text(
                                      'Add Set',
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.asap().fontFamily,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth - 40,
                        child: CupertinoButton(
                          color: Colors.blue,
                          // padding: EdgeInsets.all(9),
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
                                    addItem(0, exercise);
                                  },
                                );
                                if (selectedGifs != null &&
                                    selectedGifs.isNotEmpty) {
                                  // Do something with the selected exercises
                                  // For example, add them to the workout routines
                                  selectedGifs.forEach(
                                    (gifs) {
                                      addGifs(0, gifs);
                                    },
                                  );
                                }
                              }
                            }
                          },
                          child: Text("Add Exercise",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  // color: Colors.blue,
                                  fontFamily: GoogleFonts.asap().fontFamily,
                                  fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        child: Text('Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                // color: Colors.red,
                                fontFamily: GoogleFonts.asap().fontFamily,
                                fontSize: 18)),
                        onPressed: () {},
                        color: Colors.white24,
                        padding: EdgeInsets.all(12),
                      ),
                      CupertinoButton(
                        color: Colors.white24,
                        padding: EdgeInsets.all(9),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Discard the workout"),
                              content: const Text(
                                  "Are you sure you want to discard the workout."),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Continue ')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  },
                                  child: const Text("Discard"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Discard Workout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: GoogleFonts.asap().fontFamily,
                                fontSize: 18)),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // Center(
            //     child: ElevatedButton(
            //         onPressed: () {},
            //         child: Padding(
            //             padding: const EdgeInsets.all(12.0),
            //             child: Text("XXXXXXX",
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                     fontFamily: GoogleFonts.asap().fontFamily,
            //                     fontSize: 18)))))
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                16.0, 8.0, 16.0, 8.0), // Adjust the padding values as needed
            child: Container(
              // Customize the appearance of the bottom sheet widget
              // You can use a ListView or any other widget you need
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(LineIcons.alternateExchange),
                    title: const Text('Replace'),
                    onTap: () {
                      Navigator.pop(context, 'Replace');
                    },
                  ),
                  ListTile(
                    leading: const Icon(LineIcons.syncIcon),
                    title: const Text('Reorder'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReorderPage(exercises: exercises),
                        ),
                      ).then((result) {
                        if (result != null && result is List<String>) {
                          setState(() {
                            exercises = List.from(result);
                          });
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(LineIcons.trash),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context, 'Delete');
                      _deleteExercise(index);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToReorderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReorderPage(exercises: exercises),
      ),
    );
  }

  void _showDFWM(BuildContext context, exerciseIndex, index) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                16.0, 8.0, 16.0, 8.0), // Adjust the padding values as needed
            child: Container(
              // Customize the appearance of the bottom sheet widget
              // You can use a ListView or any other widget you need
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Mdi.alphaWBox,
                      color: Colors.orange,
                    ),
                    title: const Text(
                      'WarmUp',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'WarmUp');
                      for (int i = index + 1;
                          i < _exerciseCounters[exerciseIndex].length;
                          i++) {
                        if (_exerciseCounters[exerciseIndex][i] >= 2) {
                          _exerciseCounters[exerciseIndex][i]--;
                        }
                      }
                      _exerciseCounters[exerciseIndex][index] = 'W';
                    },
                  ),
                  ListTile(
                    leading: Icon(Mdi.alphaNBox),
                    title: const Text(
                      'Normal',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'Normal');
                      final oldIndex =
                          _exerciseCounters[exerciseIndex].indexOf('W');
                      if (oldIndex != -1) {
                        _exerciseCounters[exerciseIndex][oldIndex] =
                            oldIndex + 1;
                        for (int i = oldIndex + 1;
                            i < _exerciseCounters[exerciseIndex].length;
                            i++) {
                          _exerciseCounters[exerciseIndex][i] =
                              _exerciseCounters[exerciseIndex][i - 1] + 1;
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Mdi.alphaDBox,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Drop',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'Drop');
                      for (int i = index + 1;
                          i < _exerciseCounters[exerciseIndex].length;
                          i++) {
                        if (_exerciseCounters[exerciseIndex][i] >= 2) {
                          _exerciseCounters[exerciseIndex][i]--;
                        }
                      }
                      _exerciseCounters[exerciseIndex][index] = 'D';

                      // _exerciseCounters[exerciseIndex][index] = 'D';
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Mdi.alphaFBox,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Fail',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'Fail');
                      for (int i = index + 1;
                          i < _exerciseCounters[exerciseIndex].length;
                          i++) {
                        if (_exerciseCounters[exerciseIndex][i] >= 2) {
                          _exerciseCounters[exerciseIndex][i]--;
                        }
                      }
                      _exerciseCounters[exerciseIndex][index] = 'F';
                      // },
                      //   _exerciseCounters[exerciseIndex][index] = 'F';
                    },
                  ),
                  ListTile(
                    leading: Icon(LineIcons.trash),
                    title: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'Remove');
                      _deleteRow(exerciseIndex, index);

                      // },
                      //   _exerciseCounters[exerciseIndex][index] = 'F';
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // DataTable tableView(int exerciseIndex) {
  //   return DataTable(
  //     columnSpacing: 0,
  //     dataRowHeight: 48,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.blue),
  //       borderRadius: BorderRadius.circular(22.0),
  //     ),
  //     columns: [
  //       DataColumn(label: Text('Set')),
  //       DataColumn(label: Text('KG')),
  //       DataColumn(label: Text('Reps')),
  //       DataColumn(label: Icon(Icons.done)),
  //       DataColumn(label: Icon(Icons.delete)),
  //     ],
  //     rows: _exerciseRows[exerciseIndex].map((row) {
  //       final int index = _exerciseRows[exerciseIndex].indexOf(row);
  //       final isEvenRow = index % 2 == 0;
  //       return DataRow(
  //         color: isEvenRow
  //             ? MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2))
  //             : MaterialStateProperty.all<Color>(Colors.grey!.withOpacity(0.3)),
  //         cells: <DataCell>[
  //           DataCell(Text('${_exerciseCounters[exerciseIndex][index]}')),
  //           DataCell(TextField(
  //             controller: (row.cells[1].child as TextField).controller,
  //             decoration: InputDecoration.collapsed(hintText: '40KG'),
  //             keyboardType: TextInputType.number,
  //           )),
  //           DataCell(TextField(
  //             controller: (row.cells[2].child as TextField).controller,
  //             decoration: InputDecoration.collapsed(hintText: '12'),
  //             keyboardType: TextInputType.number,
  //           )),
  //           DataCell(Checkbox(
  //             activeColor: Colors.blue[400],
  //             value: _selectedRows[exerciseIndex][index],
  //             onChanged: (value) {
  //               setState(() {
  //                 _selectedRows[exerciseIndex][index] = value!;
  //               });
  //             },
  //           )),
  //           DataCell(
  //             IconButton(
  //               icon: Icon(Icons.delete),
  //               onPressed: () => _deleteRow(exerciseIndex, index),
  //             ),
  //           ),
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }

  Widget tableView(int exerciseIndex) {
    return Card(
      color: Colors.transparent,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      child: DataTable(
        // columnSpacing: 30,
        // dataRowHeight: 48,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.blue),
        //   borderRadius: BorderRadius.circular(22.0),
        // ),
        columns: [
          // DataColumn(label: Text('sele')),
          DataColumn(
              label: Text(
            '      Set',
            style: TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
          )),
          DataColumn(
              label: Text(
            'KG',
            style: TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
          )),
          DataColumn(
              label: Text(
            'Reps',
            style: TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
          )),
          const DataColumn(
              label: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.done),
          )),
          // const DataColumn(
          //     label: Padding(
          //   padding: EdgeInsets.all(12.0),
          //   child: Icon(Icons.delete),
          // )),
        ],
        rows: _exerciseRows[exerciseIndex].map((row) {
          final int index = _exerciseRows[exerciseIndex].indexOf(row);
          final isEvenRow = index % 2 == 0;
          final isSelectedRow = _selectedRows[exerciseIndex][index];
          return DataRow(
            selected: isSelectedRow,
            color: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green
                    .withOpacity(0.999); // Change color for selected rows
              } else if (isEvenRow) {
                return Colors.transparent; // Color for even rows
              } else {
                return Colors.grey.withOpacity(0.3); // Color for odd rows
              }
            }),
            cells: <DataCell>[
              DataCell(TextButton(
                child: Text(
                  '${_exerciseCounters[exerciseIndex][index]}',
                  style: TextStyle(
                      color: _exerciseCounters[exerciseIndex][index] == 'W'
                          ? Colors.orange
                          : _exerciseCounters[exerciseIndex][index] == 'D'
                              ? Colors.blue
                              : _exerciseCounters[exerciseIndex][index] == 'F'
                                  ? Colors.red
                                  : Colors.white, // Default color
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.asap().fontFamily,
                      fontSize: 20),
                ),
                onPressed: () {
                  _showDFWM(context, exerciseIndex, index);
                },
              )),
              DataCell(
                TextField(
                  controller: (row.cells[1].child as TextField).controller,
                  decoration: const InputDecoration.collapsed(hintText: '-'),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.asap().fontFamily),
                ),
              ),
              DataCell(
                TextField(
                  controller: (row.cells[2].child as TextField).controller,
                  decoration: const InputDecoration.collapsed(hintText: '-'),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.asap().fontFamily),
                ),
              ),
              // DataCell(
              //   Checkbox(
              //     activeColor: Colors.blue[400],
              //     value: _selectedRows[exerciseIndex][index],
              //     onChanged: (value) {
              //       setState(() {
              //         _selectedRows[exerciseIndex][index] = value!;
              //       });
              //     },
              //   ),
              // ),
              DataCell(Checkbox(
                activeColor: Colors.blue[400],
                value: _selectedRows[exerciseIndex][index],
                onChanged: (value) {
                  setState(() {
                    _selectedRows[exerciseIndex][index] = value!;
                  });
                },
              )),
              // DataCell(
              //   IconButton(
              //     icon: const Icon(Icons.delete),
              //     onPressed: () => _deleteRow(exerciseIndex, index),
              //   ),
              // ),
            ],
          );
        }).toList(),
      ),
    );
  }

  List<WorkoutSession> workoutSessions = [];

  Future<void> _finishWorkout(BuildContext context) async {
    // Check if all exercises are completed (checkboxes are active)
    bool allExercisesCompleted = true;
    for (int i = 0; i < _exerciseRows.length; i++) {
      List<DataRow> rows = _exerciseRows[i];
      for (int j = 0; j < rows.length; j++) {
        DataRow row = rows[j];
        bool? selected = _selectedRows[i][j];
        final String weightText =
            (row.cells[1].child as TextField).controller!.text;
        final String repsText =
            (row.cells[2].child as TextField).controller!.text;

        if (selected != true || weightText.isEmpty || repsText.isEmpty) {
          allExercisesCompleted = false;
          break;
        }
      }
      if (!allExercisesCompleted) {
        break;
      }
    }

    if (!allExercisesCompleted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Finish the workout"),
          content: const Text(
              "Please complete all exercises before finishing the workout."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Create a list of WorkoutData objects
    List<WorkoutData> workoutData = [];
    int counter = 1;

    // Iterate over the exercise rows and create WorkoutData objects
    for (int i = 0; i < _exerciseRows.length; i++) {
      List<Map<String, dynamic>> data = [];
      for (int j = 0; j < _exerciseRows[i].length; j++) {
        DataRow row = _exerciseRows[i][j];
        final int set = int.parse((row.cells[0].child as Text).data!);
        final int weight =
            int.parse((row.cells[1].child as TextField).controller!.text);
        final int reps =
            int.parse((row.cells[2].child as TextField).controller!.text);
        final bool? selected = _selectedRows[i][j];

        data.add({
          'set': set,
          'weight': weight,
          'reps': reps,
          'selected': selected,
        });
      }

      final String exercise = exercises[i];
      WorkoutData workout = WorkoutData(
          exercise: exercise, data: data, counter: counter, titlename: exName);
      workoutData.add(workout);
    }

    // Get the current date and time
    DateTime now = DateTime.now();

    // Create a new WorkoutSession object with the current date, time, and workout data
    WorkoutSession workoutSession = WorkoutSession(
        dateTime: now,
        workoutData: workoutData,
        titleRot: exName,
        imagePath: '');

    // Show a confirmation dialog before finishing the workout
    bool finishConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Finish the workout"),
        content: const Text("Are you sure you want to finish the workout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Return false to indicate cancel
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                  context, true); // Return true to indicate confirmation
            },
            child: const Text("Finish"),
          ),
        ],
      ),
    );

    if (finishConfirmed == true) {
      // Add the workout session to the workoutSessions list
      setState(() {
        workoutSessions.add(workoutSession);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddMediaPage(
            workoutData: workoutData,
            exName: exName,
            stopwatch: _stopwatch,
            time: _elapsedTime,
            workoutSessions: workoutSessions,
            totalSets: _totalSets,
            totalWeights: _totalWeight,
          ),
        ),
      );
      // _stopwatch.reset();
      counter++;
    }
  }
}
