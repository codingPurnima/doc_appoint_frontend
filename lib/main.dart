import 'package:doc_appoint_frontend/screens/common/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'TiroDevanagariHindi',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 6, 24, 39),
          toolbarHeight: 85,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),


        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C6F82), width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C6F82), width: 2.5),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),


        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF0E2A47),
          behavior: SnackBarBehavior.fixed,
        ),


        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 6, 24, 39)),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          )
        ),


        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Color(0xFF212121)),
          contentTextStyle: TextStyle(color: Color(0xFF616161)),
        ),


        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          subtitleTextStyle: TextStyle(
            color: Color(0xFF757575),
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),


        scaffoldBackgroundColor: Color(0xFFE2E8F0),
      ),
    );
  }
}