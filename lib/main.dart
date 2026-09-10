import 'package:doc_appoint_frontend/screens/common/splash_screen.dart';
import 'package:doc_appoint_frontend/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocAppoint',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}