import 'package:doc_appoint_frontend/screens/common/login_screen.dart';
import 'package:doc_appoint_frontend/screens/doctor/doctor_main_screen.dart';
import 'package:doc_appoint_frontend/screens/patient/patient_main_screen.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:doc_appoint_frontend/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Resolve authentication before creating the Flutter app.
  final Widget initialScreen = await _resolveInitialScreen();
  runApp(
    ProviderScope(
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}

Future<Widget> _resolveInitialScreen() async {
  final authService = AuthService();

  try {
    // Restore the saved session.
    await authService.loadTokens();

    // If there is no access token, attempt to refresh the session.
    final accessToken = AuthService.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      await authService.refreshAccessToken();
    }

    // Authentication could not be established.
    if (!AuthService.isLoggedIn) {
      return const LoginScreen();
    }

    // Open the correct home screen based on the saved role.
    switch (AuthService.role) {
      case 'doctor':
        return const DoctorMainScreen();

      case 'patient':
        return const PatientMainScreen();

      default:
        return const LoginScreen();
    }
  } catch (error, stackTrace) {
    // Handle startup failures without crashing the app.
    // A temporary network failure should not automatically erase saved tokens.
    debugPrint('Startup authentication failed: $error');
    debugPrintStack(stackTrace: stackTrace);

    return const LoginScreen();
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({
    super.key,
    required this.initialScreen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocAppoint',
      home: initialScreen,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}