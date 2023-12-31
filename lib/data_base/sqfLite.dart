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
      print('----savedIn DB----');
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

  Future<List<WorkoutSession>> loadWorkoutSessions() async {
    final db = await database;

    // Fetch all workout sessions from the workout_session table
    List<Map<String, dynamic>> sessionRows = await db.query('workout_session');

    List<WorkoutSession> workoutSessions = [];

    // Iterate over each session row and fetch the corresponding workout data entries
    for (Map<String, dynamic> sessionRow in sessionRows) {
      int sessionId = sessionRow['id'] as int;

      // Fetch workout data entries for the current session from the workout_data table
      List<Map<String, dynamic>> dataRows = await db.query(
        'workout_data',
        where: 'sessionId = ?',
        whereArgs: [sessionId],
      );

      List<WorkoutData> workoutData = [];

      // Iterate over each data row and convert it to WorkoutData object
      for (Map<String, dynamic> dataRow in dataRows) {
        WorkoutData workout = WorkoutData(
          exercise: dataRow['exercise'] as String,
          data: jsonDecode(dataRow['data'] as String),
          counter: dataRow['counter'] as int,
          titlename: dataRow['titlename'] as String,
        );

        workoutData.add(workout);
      }

      // Create WorkoutSession object and add it to the list
      WorkoutSession session = WorkoutSession(
        dateTime: DateTime.parse(sessionRow['dateTime'] as String),
        workoutData: workoutData,
        titleRot: sessionRow['titleRot'],
        imagePath: sessionRow['imagePath'],
      );

      workoutSessions.add(session);
    }

    return workoutSessions;
  }
}
