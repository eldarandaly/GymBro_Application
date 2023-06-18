import 'dart:async';
import 'dart:convert';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();

  late Database _database;
  bool _isDatabaseInitialized = false;

  Future<Database> get database async {
    if (!_isDatabaseInitialized) {
      _database = await initDatabase();
      _isDatabaseInitialized = true;
    }
    return _database;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'workout.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE workout_session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dateTime TEXT,
            titleRot TEXT,
            imagePath TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE workout_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sessionId INTEGER,
            exercise TEXT,
            data TEXT,
            counter INTEGER,
            titlename TEXT,
            FOREIGN KEY (sessionId) REFERENCES workout_session (id)
          )
        ''');
      },
    );
  }

  Future<int> insertWorkoutData(
      int sessionId, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('workout_data', {
      'exercise': data['exercise'],
      'data': jsonEncode(data['data']),
      'counter': data['counter'],
      'titlename': data['titlename'],
      'sessionId': sessionId, // Foreign key reference to workout_session
    });
  }

  Future<bool> insertWorkoutSession(WorkoutSession session) async {
    try {
      final db = await database;

      // Insert the workout session into the workout_session table
      int sessionId = await db.insert('workout_session', {
        'dateTime': session.dateTime.toIso8601String(),
        'imagePath': session.imagePath,
      });

      // Insert each workout data entry into the workout_data table
      for (Map<String, dynamic> data
          in session.workoutData.map((workout) => workout.toJson())) {
        await insertWorkoutData(sessionId, data);
      }

      return true;
    } catch (e) {
      print('Error inserting workout session: $e');
      return false;
    }
  }

  Future<int> getLastInsertedSessionId() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.rawQuery('SELECT last_insert_rowid();');
    int sessionId = results.first.values.first as int;
    return sessionId;
  }
}
