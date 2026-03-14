import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> navItems;
  const MainScreen({super.key, required this.screens, required this.navItems});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: const Color(0xFF061827),
        items: widget.navItems,
      ),
    );
  }
}
