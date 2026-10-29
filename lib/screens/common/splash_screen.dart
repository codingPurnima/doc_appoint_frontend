// import 'package:doc_appoint_frontend/screens/common/login_screen.dart';
// import 'package:doc_appoint_frontend/screens/doctor/doctor_main_screen.dart';
// import 'package:doc_appoint_frontend/screens/patient/patient_main_screen.dart';
// import 'package:doc_appoint_frontend/services/auth_service.dart';
// import 'package:doc_appoint_frontend/theme/app_theme.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkLogin();
//   }

//   Future<void> checkLogin() async {
//     final splashStartedAt = DateTime.now();
//     final authService = AuthService();

//     await authService.loadTokens();

//     String? token = AuthService.accessToken;
//     final role = AuthService.role;

//     token ??= await authService.refreshAccessToken();

//     // Keep the custom splash visible for at least 1.2 seconds.
//     final elapsed = DateTime.now().difference(splashStartedAt);
//     const minimumSplashDuration = Duration(milliseconds: 1200);

//     if (elapsed < minimumSplashDuration) {
//       await Future.delayed(minimumSplashDuration - elapsed);
//     }

//     if (!mounted) return;

//     if (AuthService.isLoggedIn && role == "doctor") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const DoctorMainScreen(),
//         ),
//       );
//     } else if (AuthService.isLoggedIn &&
//         role == "patient") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const PatientMainScreen(),
//         ),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const LoginScreen(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 120,
//                 height: 120,
//                 child: Image.asset(
//                   'assets/icons/DocAppointLogo.png',
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(
//                       Icons.broken_image,
//                       color: Colors.white,
//                       size: 48,
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 "DocAppoint",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 32,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Doctor Appointments Made Simple",
//                 style: TextStyle(
//                   color: Colors.white.withValues(alpha: 0.7),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//               const SizedBox(height: 48),
//               SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.white.withValues(alpha: 0.7),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
