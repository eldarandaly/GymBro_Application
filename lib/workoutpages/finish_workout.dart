import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/constants.dart';
import 'package:gymbro/home/my_routine_page.dart';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMediaPage extends StatefulWidget {
  final List<WorkoutData> workoutData;
  final String exName;
  final Stopwatch stopwatch;
  final List<WorkoutSession> workoutSessions;
  final int totalSets;
  final int totalWeights;
  final String time;

  AddMediaPage(
      {required this.workoutData,
      required this.exName,
      required this.stopwatch,
      required this.workoutSessions,
      required this.totalSets,
      required this.totalWeights,
      required this.time});

  @override
  _AddMediaPageState createState() => _AddMediaPageState();
}

class _AddMediaPageState extends State<AddMediaPage> {
  // File? _imageFile;
  String workoutName = '';
  late List<WorkoutData> workoutData2;
  late List<WorkoutSession> _workoutSessions;
  late SharedPreferences _prefs;
  String _imageData = '';
  int _totalSets = 0;
  int _totalWeights = 0;
  String _time = '';

  @override
  void initState() {
    super.initState();
    workoutName = widget.exName;
    workoutData2 = widget.workoutData;
    _workoutSessions = widget.workoutSessions;
    _totalSets = widget.totalSets;
    _totalWeights = widget.totalWeights;
    _time = widget.time;
    // loadProfileImage();
  }

  // Future<void> loadProfileImage() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _imageData = _prefs.getString('profileImage');
  //   });
  // }

  Future<void> _pickImage(ImageSource source) async {
    // final pickedImage = await ImagePicker().pickImage(source: source);

    if (source == ImageSource.camera) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        final fileData = File(pickedImage.path);
        final imageData = await fileData.readAsBytes();
        final base64ImageData = base64Encode(imageData);

        setState(() {
          _imageData = base64ImageData;
        });
      }
    }
    if (source == ImageSource.gallery) {
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

        // _prefs.setString('profileImage', base64ImageData);
      }
    }
  }

  void _saveMedia(BuildContext context) {
    DateTime now = DateTime.now();

    // Create a new WorkoutSession object with the current date, time, and workout data
    WorkoutSession workoutSession = WorkoutSession(
        dateTime: now,
        workoutData: workoutData2,
        titleRot: workoutName,
        imagePath: _imageData);

    Provider.of<WorkoutDataProvider>(context, listen: false).saveWorkoutData();
    Provider.of<WorkoutDataProvider>(context, listen: false)
        .addWorkoutSession(workoutSession);
    widget.stopwatch.reset();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Finish the Workout'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Good Workout Keep Doing $workoutName',
                style: headingStyle2,
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.blue,
                          ),
                          Text(
                            '$_time',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 20.0,
                              color: Colors.black,
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
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '$_totalWeights KG',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 18.0,
                              color: Colors.black,
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
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '$_totalSets',
                            style: TextStyle(
                              fontFamily: GoogleFonts.asap().fontFamily,
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choose Image"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text("Choose from Gallery"),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text("Take a Photo"),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_imageData.isNotEmpty)
                              Container(
                                // height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                            base64Decode(_imageData)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedBorder(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 33,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: () {
                  _saveMedia(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
