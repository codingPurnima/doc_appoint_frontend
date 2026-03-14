import 'package:doc_appoint_frontend/screens/doctor/doctor_home_screen.dart';
import 'package:doc_appoint_frontend/screens/common/login_screen.dart';
import 'package:doc_appoint_frontend/screens/patient/patient_main_screen.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

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
    checkLogin(); //if you keep it here, this function gets called automatically when initState() is called, so there is no need of pressing the button
  }

  Future<void> checkLogin() async {
    final authService = AuthService();

    // Load tokens from SharedPreferences
    await authService.loadTokens();

    String? token = AuthService.accessToken;
    String? role = AuthService.role;

    // If access token missing, try refreshing
    token ??= await authService.refreshAccessToken();

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (AuthService.isLoggedIn && role=="doctor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
      );
    } else if (AuthService.isLoggedIn && role=="patient") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientMainScreen()),
      );
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
    );
  }
}
