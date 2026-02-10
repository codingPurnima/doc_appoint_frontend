import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                fontSize: 50,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Icon(
        Icons.start_rounded,
        color: Colors.white,
        size: 100,
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