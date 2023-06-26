import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class WorkoutPlanForm extends StatefulWidget {
  const WorkoutPlanForm({Key? key}) : super(key: key);

  @override
  _WorkoutPlanFormState createState() => _WorkoutPlanFormState();
}

class _WorkoutPlanFormState extends State<WorkoutPlanForm> {
  // Define the user's preferences as instance variables
  String fitnessGoal = 'Lose weight';
  String workoutType = 'Cardio';
  String fitnessLevel = 'Beginner';
  String workoutFrequency = '1-2 times per week';
  int workoutDuration = 3;
  // Define loading and response state
  bool isLoading = false;
  bool isSubmitted = false;
  WorkoutPlan? workoutPlan;

  // Define a function to handle the form submission
  Future<void> submitForm() async {
    // Show a loading indicator
    setState(() {
      isLoading = true;
      isSubmitted = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://gymbro-81509.web.app'),
        body: {
          'fitnessGoal': fitnessGoal,
          'workoutType': workoutType,
          'fitnessLevel': fitnessLevel,
          'workoutFrequency': workoutFrequency,
          'workoutDuration': workoutDuration.toString(),
        },
      );

      if (response.statusCode == 200) {
        final workoutPlan = jsonDecode(response.body)['workout_plan'];

        // Show the workout plan on the screen
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Workout Plan'),
            content: SingleChildScrollView(
              child: Html(data: workoutPlan),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );

        setState(() {
          isLoading = false;
          isSubmitted = true;
        });
      } else {
        // Handle API error
        print('API Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
          isSubmitted = false;
        });
      }
    } catch (e) {
      // Handle network or server error
      print('Error: $e');
      setState(() {
        isLoading = false;
        isSubmitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // make the background transparent
        elevation: 0, // remove the shadow
        /* leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black, // set the icon color to black
          ),
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black, // set the icon color to black
            ),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.black, // set the icon color to black
            ),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ], */
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '🥇 What is your fitness level?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              CupertinoSlidingSegmentedControl(
                groupValue: fitnessLevel,
                // ignore: prefer_const_literals_to_create_immutables
                children: {
                  'Beginner': const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Beginner', style: TextStyle(fontSize: 14.0)),
                  ),
                  'Intermediate': const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child:
                        Text('Intermediate', style: TextStyle(fontSize: 14.0)),
                  ),
                  'Advanced': const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Advanced', style: TextStyle(fontSize: 14.0)),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    fitnessLevel = value as String;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                '🎯 What is your fitness goal?',
                style: TextStyle(fontSize: 18),
              ),
              DropdownButton<String>(
                value: fitnessGoal,
                onChanged: (value) {
                  setState(() {
                    fitnessGoal = value!;
                  });
                },
                items: ['Lose weight', 'Build muscle', 'Improve endurance']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                          ),
                        ))
                    .toList(),
                elevation: 2,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 32.0,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
                isExpanded: true,
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏋️‍♀️ What type of workout do you prefer?',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: ListView.builder(
                      itemCount: workoutTypes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                workoutType = workoutTypes[index];
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: workoutType == workoutTypes[index]
                                        ? Colors.grey[600]
                                        : Colors.grey[300],
                                  ),
                                  child: Text(workoutTypeIcons[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 36.0,
                                        color:
                                            workoutType == workoutTypes[index]
                                                ? Colors.white
                                                : Colors.black,
                                      )),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  workoutTypes[index],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              const Text('📅 How often do you want to work out?',
                  style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: workoutFrequency,
                onChanged: (value) {
                  setState(() {
                    workoutFrequency = value!;
                  });
                },
                items: [
                  '1-2 times per week',
                  '3-4 times per week',
                  '5-6 times per week'
                ]
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                elevation: 2,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 32.0,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
                isExpanded: true,
              ),
              const SizedBox(height: 16.0),
              const Text('How many days should the workout plan cover?',
                  style: TextStyle(fontSize: 18)),
              SliderTheme(
                  data: const SliderThemeData(
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  child: Slider(
                    value: workoutDuration.toDouble(),
                    min: 1,
                    max: 30,
                    onChanged: (value) {
                      setState(() {
                        workoutDuration = value.toInt();
                      });
                    },
                    label: '$workoutDuration days',
                    divisions: 29,
                    activeColor: Colors.white,
                    inactiveColor: Colors.black,
                  )),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading ? null : submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16.0),
              if (isLoading)
                Column(
                  children: [
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "This may take a few seconds to generate your workout plan. Please don't close the app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              if (isSubmitted)
                Text(
                  'Workout Plan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              if (isSubmitted)
                Html(data: workoutPlan!.choices![0].message!.content!, style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    color: Colors.black,
                  ),
                  "h1": Style(
                    fontSize: FontSize(24.0),
                    color: Colors.black,
                  ),
                  "h2": Style(
                    fontSize: FontSize(20.0),
                    color: Colors.black,
                  ),
                  "h3": Style(
                    fontSize: FontSize(18.0),
                    color: Colors.black,
                  ),
                  "h4": Style(
                    fontSize: FontSize(16.0),
                    color: Colors.black,
                  ),
                  "h5": Style(
                    fontSize: FontSize(14.0),
                    color: Colors.black,
                  ),
                  "h6": Style(
                    fontSize: FontSize(12.0),
                    color: Colors.black,
                  ),
                  "p": Style(
                    fontSize: FontSize(16.0),
                    color: Colors.black,
                  ),
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutPlan {
  String? id;
  String? object;
  int? created;
  String? model;
  Usage? usage;
  List<Choices>? choices;

  WorkoutPlan(
      {this.id,
      this.object,
      this.created,
      this.model,
      this.usage,
      this.choices});

  WorkoutPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    created = json['created'];
    model = json['model'];
    usage = json['usage'] != null ? Usage.fromJson(json['usage']) : null;
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(Choices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['created'] = created;
    data['model'] = model;
    if (usage != null) {
      data['usage'] = usage!.toJson();
    }
    if (choices != null) {
      data['choices'] = choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Usage {
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  Usage({this.promptTokens, this.completionTokens, this.totalTokens});

  Usage.fromJson(Map<String, dynamic> json) {
    promptTokens = json['prompt_tokens'];
    completionTokens = json['completion_tokens'];
    totalTokens = json['total_tokens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prompt_tokens'] = promptTokens;
    data['completion_tokens'] = completionTokens;
    data['total_tokens'] = totalTokens;
    return data;
  }
}

class Choices {
  Message? message;
  String? finishReason;
  int? index;

  Choices({this.message, this.finishReason, this.index});

  Choices.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    finishReason = json['finish_reason'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['finish_reason'] = finishReason;
    data['index'] = index;
    return data;
  }
}

class Message {
  String? role;
  String? content;

  Message({this.role, this.content});

  Message.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}

List<String> workoutTypes = [
  'Cardio',
  'Weightlifting',
  'Strength training',
  'Yoga',
  'Stretching',
  'Other'
];
List<String> workoutTypeIcons = [
  "🏃‍♂️",
  "🏋️‍♂️",
  "💪",
  "🧘‍♂️",
  "🤸‍♂️",
  "🤷‍♂️"
];
