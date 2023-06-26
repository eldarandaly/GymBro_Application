import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/constants.dart';
import 'package:gymbro/data_base/local_api.dart';
import 'package:gymbro/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class ApiClass extends StatefulWidget {
  @override
  _ApiClassState createState() => _ApiClassState();
}

class _ApiClassState extends State<ApiClass> {
  List<dynamic> exercises = Exercise.exercises;
  Map<String?, dynamic> exercisesImages = Exercise.images;
  List<String> equipment = [
    "assisted",
    "band",
    "barbell",
    "body only",
    "kettlebells",
    "cable",
    "dumbbell",
    "resistance band",
    "machine",
    "smith machine",
    "other",
    "e-z curl bar",
    "foam roll",
    "medicine ball",
    "exercise ball",
  ]; // Example body parts
  List<String> targets = [
    "abductors",
    "abs",
    "adductors",
    "biceps",
    "calves",
    "cardiovascular system",
    "delts",
    "forearms",
    "glutes",
    "hamstrings",
    "lats",
    "levator scapulae",
    "chest",
    "quads",
    "serratus anterior",
    "spine",
    "traps",
    "triceps",
    "upper back"
  ];

  List<String> selectedEquipment = [];
  List<String> selectedTargets = [];
  List<String> selectedExercises = [];
  List<String> selectedExeGifs = [];

  String searchQuery = '';
  String selectedTarget = '';
  String selectedEq = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // fetchExercises();
    Exercise.loadExerciseData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Future<void> fetchExercises() async {
  //   final apiKey = 'e74a38207dmsh4c7c7032cb8ee56p18ca6djsne27f29a927c7';
  //   final exercisesapiUrl = "https://exercisedb.p.rapidapi.com/exercises";
  //   final response = await http.get(
  //     Uri.parse(exercisesapiUrl),
  //     headers: {
  //       'X-RapidAPI-Key': apiKey,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final decodedResponse = jsonDecode(response.body);
  //     setState(() {
  //       exercises = decodedResponse;
  //     });
  //   } else {
  //     throw Exception('Failed to fetch exercises');
  //   }
  // }

  String getImageForTarget(String target) {
    switch (target) {
      case "abductors":
        return "https://www.shutterstock.com/image-illustration/triceps-anatomy-muscles-isolated-on-600w-421144870.jpg";
      case "abs":
        return "https://www.shutterstock.com/image-illustration/rectus-abdominis-anatomy-abs-muscles-600w-421145416.jpg";
      case "adductors":
        return "https://www.shutterstock.com/image-illustration/adductor-brevis-longus-anatomy-muscles-600w-421145404.jpg";
      case "biceps":
        return "https://www.shutterstock.com/image-illustration/biceps-anatomy-muscles-isolated-on-600w-421145389.jpg";
      case "calves":
        return "https://www.shutterstock.com/image-illustration/calf-muscle-male-gastrocnemius-plantar-600w-421145395.jpg";
      case "cardiovascular system":
        return "https://www.shutterstock.com/image-illustration/calf-muscle-male-gastrocnemius-plantar-600w-421145395.jpg";
      case "delts":
        return "https://www.shutterstock.com/image-illustration/deltoid-anatomy-muscles-isolated-on-600w-421145437.jpg";
      case "forearms":
        return "https://www.shutterstock.com/image-illustration/forearm-anatomy-muscles-isolated-on-600w-421145458.jpg";
      case "glutes":
        return "https://www.shutterstock.com/image-illustration/gluteus-maximus-anatomy-muscles-isolated-600w-421145407.jpg";
      case "hamstrings":
        return "https://www.shutterstock.com/image-illustration/hamstrings-anatomy-muscle-isolated-on-600w-421145413.jpg";
      case "lats":
        return "https://www.shutterstock.com/image-illustration/latissimus-dorsi-anatomy-muscles-isolated-600w-421145380.jpg";
      case "levator scapulae":
        return "https://www.shutterstock.com/image-illustration/teres-major-minor-infraspinatus-supraspinatus-600w-421145422.jpg";
      case "chest":
        return "https://www.shutterstock.com/image-illustration/chest-pectoralis-major-minor-anatomy-600w-421145401.jpg";
      case "quads":
        return "https://www.shutterstock.com/image-illustration/quadriceps-male-muscles-anatomy-muscle-600w-489727177.jpg";
      case "serratus anterior":
        return "https://www.shutterstock.com/image-illustration/serratus-anterior-anatomy-muscles-isolated-600w-421145383.jpg";
      // case "spine":
      //   return "https://www.shutterstock.com/image-illustration/chest-pectoralis-major-minor-anatomy-600w-421145401.jpg";
      case "traps":
        return "https://www.shutterstock.com/image-illustration/trapezius-anatomy-muscles-isolated-on-600w-421145371.jpg";
      case "triceps":
        return "https://www.shutterstock.com/image-illustration/triceps-anatomy-muscles-isolated-on-600w-421144870.jpg";
      case "upper back":
        return "https://www.shutterstock.com/image-illustration/teres-major-minor-infraspinatus-supraspinatus-600w-421145422.jpg";
      default:
        return "https://www.shutterstock.com/image-illustration/blank-anatomy-figure-white-male-600w-129031004.jpg"; // Return an empty string or default image URL if target is not found
    }
  }

  String getImageForEquipment(String equipment) {
    switch (equipment) {
      case "band":
        return "https://www.shutterstock.com/image-vector/resistance-band-icon-fitness-health-600w-1712436832.jpg";
      case "barbell":
        return "https://www.shutterstock.com/image-vector/barbells-bar-vector-gym-equipment-600w-2295921473.jpg";
      case "body only":
        return "https://www.shutterstock.com/image-vector/single-continuous-line-drawing-young-600w-1663866613.jpg";
      case "cable":
        return "https://www.shutterstock.com/image-vector/double-handle-tricep-rope-concept-600w-2315514231.jpg";
      case "dumbbell":
        return "https://www.shutterstock.com/image-vector/dumbbells-vector-isolated-gym-equipment-600w-2295854785.jpg";
      case "machine":
        return "https://www.shutterstock.com/image-illustration/different-fitness-training-equipment-weight-600w-100913788.jpg";
      case "smith machine":
        return "https://www.shutterstock.com/image-illustration/incline-smith-machine-bench-press-600w-429857722.jpg";
      case "e-z curl bar":
        return "https://www.shutterstock.com/image-vector/barbells-bar-vector-gym-equipment-600w-2295921491.jpg";
      case "foam roll":
        return "https://www.shutterstock.com/image-vector/sports-tool-fitness-massage-foam-600w-2155125239.jpg";
      case "other":
        return "https://thenounproject.com/api/private/icons/3264341/edit/?backgroundShape=SQUARE&backgroundShapeColor=%23000000&backgroundShapeOpacity=0&exportSize=752&flipX=false&flipY=false&foregroundColor=%23000000&foregroundOpacity=1&imageFormat=png&rotation=0";
      default:
        return "https://thenounproject.com/api/private/icons/3264341/edit/?backgroundShape=SQUARE&backgroundShapeColor=%23000000&backgroundShapeOpacity=0&exportSize=752&flipX=false&flipY=false&foregroundColor=%23000000&foregroundOpacity=1&imageFormat=png&rotation=0"; // Return an empty string or default image URL if target is not found
    }
  }

  void _toggleExercise(String exerciseName) {
    setState(() {
      if (selectedExercises.contains(exerciseName)) {
        selectedExercises.remove(exerciseName);
      } else {
        selectedExercises.add(exerciseName);
      }
    });
  }

  void _toggleGifs(String gifUrl) {
    setState(() {
      if (selectedExeGifs.contains(gifUrl)) {
        selectedExeGifs.remove(gifUrl);
      } else {
        selectedExeGifs.add(gifUrl);
      }
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

  void _showTargetMenu() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 666,
            child: SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Text(
                    'data',
                    style: headingStyle,
                  ),
                  Column(
                    children: targets.map((String target) {
                      return Column(
                        children: [
                          ListTile(
                            titleTextStyle: TextStyle(fontSize: 22),
                            leading: CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(getImageForTarget(target)),
                            ),
                            title: Text(target),
                            onTap: () {
                              setState(() {
                                selectedTargets = [target];
                                selectedTarget = target;
                              });
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEquipmentMenu() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 666,
          child: SingleChildScrollView(
            child: Column(
              children: equipment.map((String equipment) {
                return Column(
                  children: [
                    ListTile(
                      titleTextStyle: TextStyle(fontSize: 22),
                      leading: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(getImageForEquipment(equipment)),
                      ),
                      // titleTextStyle: TextStyle(fontSize: 33),
                      title: Text(equipment),
                      onTap: () {
                        setState(() {
                          selectedEquipment = [equipment];
                          selectedEq = equipment;
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
        selectedTargets = targets
            .where((target) =>
                target.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Exercises',
                    style:
                        TextStyle(fontFamily: GoogleFonts.asap().fontFamily)),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                style: TextStyle(
                  fontFamily: GoogleFonts.asap().fontFamily,
                  // fontSize: 24.0,
                  color: Colors.blue,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search exercise',
                  hintStyle:
                      TextStyle(fontFamily: GoogleFonts.asap().fontFamily),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth / 2 - 30,
                child: TextButton(
                  onPressed: _showEquipmentMenu,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue.withOpacity(
                              0.8); // Set the background color when pressed
                        }
                        if (selectedEq.isNotEmpty) {
                          return Colors
                              .blue; // Set the background color when selected
                        }
                        return Colors
                            .grey[700]!; // Set the default background color
                      },
                    ),
                  ),
                  child: Text(
                    selectedEq.isNotEmpty ? selectedEq : 'Select Equipment',
                    style: TextStyle(
                      fontFamily: GoogleFonts.asap().fontFamily,
                      fontSize: 20.0,
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth / 2 - 30,
                child: TextButton(
                  onPressed: _showTargetMenu,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue.withOpacity(
                              0.8); // Set the background color when pressed
                        }
                        if (selectedTarget.isNotEmpty) {
                          return Colors
                              .blue; // Set the background color when selected
                        }
                        return Colors
                            .grey[700]!; // Set the default background color
                      },
                    ),
                  ),
                  child: Text(
                    selectedTarget.isNotEmpty
                        ? selectedTarget
                        : 'Select Target',
                    style: TextStyle(
                      fontFamily: GoogleFonts.asap().fontFamily,
                      fontSize: 20.0,
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
              if (selectedEq.isNotEmpty || selectedTarget.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedEq = ''; // Reset the selected equipment
                      selectedTarget = ''; // Reset the selected target
                    });
                  },
                  icon: Icon(Icons.remove_circle),
                  color: Colors.white,
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                final imagesGifs = exercisesImages;

                // Apply filters
                if (selectedEquipment.isNotEmpty &&
                    !selectedEquipment.contains(exercise.equipment)) {
                  return SizedBox.shrink();
                }
                if (selectedTargets.isNotEmpty &&
                    !selectedTargets.contains(exercise.primaryMuscles.first)) {
                  return SizedBox.shrink();
                }

                final exerciseName = exercise.name as String;
                final _exerciseName =
                    exercise.name?.replaceAll(RegExp(r'[\/\s]'), '_');

                final exerciseGif = imagesGifs[_exerciseName]
                    [0]; //exercise['gifUrl'] as String;
                final exerciseGif2 = imagesGifs[_exerciseName];
                // Check if exercise name contains the search query
                if (exerciseName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())) {
                  final isChecked = selectedExercises.contains(exerciseName);
                  final isCheckedGif = selectedExercises.contains(exerciseGif);

                  return ListTile(
                    onTap: () => _openGif(exerciseGif2),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            activeColor: Colors.blue,
                            value: isChecked,
                            onChanged: (bool? value) {
                              _toggleExercise(exerciseName);
                              // _toggleGifs(exerciseGif);
                            },
                            title: Text(
                              exerciseName,
                              style: TextStyle(
                                fontFamily: GoogleFonts.asap().fontFamily,
                                fontSize: 20.0,
                                color: Colors.white, // Set the text color
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    leading: Container(
                      child: Image(
                        width: 100,
                        height: 100,
                        image: exerciseGif,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pop(context, [selectedExercises, selectedExeGifs]);
        },
        child: Icon(
          Icons.check,
        ),
      ),
    );
  }
}
