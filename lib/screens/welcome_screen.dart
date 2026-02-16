import 'package:doc_appoint_frontend/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // the context thing doesn't work here since we are using a StatelessWidget
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          tooltip: 'Begin',
          backgroundColor: const Color.fromARGB(255, 6, 24, 39),
          child: Icon(Icons.start_rounded, color: Colors.white, size: 80),
        ),
      ),
    );
  }
}



// appBar: AppBar(
//         title: Text(
//           "DocAppoint",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 50,
//           )
//         ),
//         backgroundColor: const Color.fromARGB(255, 6, 24, 39),
//         centerTitle: true,
//         toolbarHeight: 125,
//       ),