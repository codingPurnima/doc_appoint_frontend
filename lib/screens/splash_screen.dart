import 'package:doc_appoint_frontend/screens/patient_main_screen.dart';
import 'package:doc_appoint_frontend/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // the context thing didn't work here since we were using a StatelessWidget earlier
  // now we need StatefulWidget to allow auto direct to patient main screen

  @override
  void initState() {
    super.initState();
    // checkLogin();    if you keep it here, this function gets called automatically when initState() is called, so there is no chance of pressing the button
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    await Future.delayed(const Duration(seconds: 1));

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientMainScreen()),
      );
    }
    else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 24, 39),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "DocAppoint",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 70,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: checkLogin,
          tooltip: 'Begin',
          backgroundColor: const Color.fromARGB(255, 6, 24, 39),
          child: Icon(Icons.start_rounded, color: Colors.white, size: 80),
        ),
      ),
    );
  }
}
