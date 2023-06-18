import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ExerciseLevel {
  none,
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive,
}

class CaloriePage extends StatefulWidget {
  @override
  _CaloriePageState createState() => _CaloriePageState();
}

class _CaloriePageState extends State<CaloriePage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  ExerciseLevel exerciseLevel = ExerciseLevel.none;
  double? bmiResult;
  double? cuttingCalories;
  double? bulkingCalories;
  double? maintenanceCalories;

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    if (height > 0 && weight > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      setState(() {
        bmiResult = bmi;
      });
    }
  }

  void calculateCalories() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double age = double.tryParse(ageController.text) ?? 0.0;
    double activityMultiplier = 0.0;

    switch (exerciseLevel) {
      case ExerciseLevel.none:
        activityMultiplier = 1.0;
        break;
      case ExerciseLevel.sedentary:
        activityMultiplier = 1.2;
        break;
      case ExerciseLevel.lightlyActive:
        activityMultiplier = 1.375;
        break;
      case ExerciseLevel.moderatelyActive:
        activityMultiplier = 1.55;
        break;
      case ExerciseLevel.veryActive:
        activityMultiplier = 1.725;
        break;
      case ExerciseLevel.extraActive:
        activityMultiplier = 1.9;
        break;
    }

    if (weight > 0 && age > 0) {
      double cutting = weight * 20 * activityMultiplier;
      double bulking = weight * 22 * activityMultiplier;
      double maintenance = weight * 21 * activityMultiplier;
      setState(() {
        cuttingCalories = cutting;
        bulkingCalories = bulking;
        maintenanceCalories = maintenance;
      });
    }
  }

  String getBmiRange(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text('Calorie Calculator',
                    style:
                        TextStyle(fontFamily: GoogleFonts.asap().fontFamily)),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<ExerciseLevel>(
                value: exerciseLevel,
                onChanged: (ExerciseLevel? newValue) {
                  setState(() {
                    exerciseLevel = newValue!;
                  });
                },
                items: ExerciseLevel.values.map((level) {
                  return DropdownMenuItem<ExerciseLevel>(
                    value: level,
                    child: Text(level.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Exercise Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () {
                  calculateBMI();
                  calculateCalories();
                },
                child: Text('Calculate'),
              ),
            ),
            bmiResult != null
                ? Column(
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        'BMI: ${bmiResult!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        'BMI Range: ${getBmiRange(bmiResult!)}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 16.0),
            cuttingCalories != null
                ? Text(
                    'Cutting Calories: ${cuttingCalories!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0),
                  )
                : SizedBox(),
            bulkingCalories != null
                ? Text(
                    'Bulking Calories: ${bulkingCalories!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0),
                  )
                : SizedBox(),
            maintenanceCalories != null
                ? Text(
                    'Maintenance Calories: ${maintenanceCalories!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          heightController.clear();
          weightController.clear();
          ageController.clear();
          setState(() {
            bmiResult = null;
            cuttingCalories = null;
            bulkingCalories = null;
            maintenanceCalories = null;
            exerciseLevel = ExerciseLevel.none;
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}
