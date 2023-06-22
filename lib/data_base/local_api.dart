import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Exercise {
  final String? name;
  final String? force;
  final String? level;
  final String? mechanic;
  final String? equipment;
  final List<String?>? primaryMuscles;
  final List<String?>? secondaryMuscles;
  final List<String?>? instructions;
  final String? category;

  Exercise({
    this.name,
    this.force,
    this.level,
    this.mechanic,
    this.equipment,
    this.primaryMuscles,
    this.secondaryMuscles,
    this.instructions,
    this.category,
  });
  static Map<String?, List<ImageProvider>> _exercisesImages = {};
  static List<Exercise> _exercises = [];

  static Map<String?, List<ImageProvider>> get images => _exercisesImages;
  static List<Exercise> get exercises => _exercises;

  factory Exercise.fromJson(Map<String?, dynamic> json) {
    return Exercise(
      name: json['name'],
      force: json['force'],
      level: json['level'],
      mechanic: json['mechanic'],
      equipment: json['equipment'],
      primaryMuscles:
          (json['primaryMuscles'] as List<dynamic>? ?? []).cast<String>(),
      secondaryMuscles:
          (json['secondaryMuscles'] as List<dynamic>? ?? []).cast<String>(),
      instructions:
          (json['instructions'] as List<dynamic>? ?? []).cast<String>(),
      category: json['category'],
    );
  }

  static Future<void> loadExerciseData() async {
    final jsonString = await rootBundle.loadString('assets/exercises.json');
    final jsonData = json.decode(jsonString);
    final exercisesData = jsonData['exercises'] as List<dynamic>;

    _exercises =
        exercisesData.map((exercise) => Exercise.fromJson(exercise)).toList();

    for (final exercise in _exercises) {
      final exerciseName = exercise.name?.replaceAll(RegExp(r'[\/\s]'), '_');
      final exerciseImages = <ImageProvider>[];
      for (int i = 0; i < 2; i++) {
        final imageName = '$i.jpg';
        final imageBytes = await rootBundle.load(
            'assets/exercisesJson/exercises/$exerciseName/images/$imageName');
        final image = MemoryImage(imageBytes.buffer.asUint8List());
        exerciseImages.add(image);
      }
      _exercisesImages[exerciseName] = exerciseImages;
    }
    // _exercisesImages[exerciseName] = exerciseImages;
  }
}
