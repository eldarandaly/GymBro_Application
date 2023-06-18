import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymbro/workoutpages/start_workout.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WorkoutDataProvider>(
          create: (context) => WorkoutDataProvider()..loadWorkoutData(),
        ),
        // Add other providers if needed
      ],
      child: SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (BuildContext context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Colors.black87,
                textTheme: TextTheme(
                    bodyText1: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.asap().fontFamily,
                ))),
            home: SplashScreen(),
          ),
        ),
      ),
    ),
  );
}
