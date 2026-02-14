import 'package:flutter/material.dart';
import '../models/slot.dart';

class PatientHomeScreen extends StatefulWidget {
  final String token;
  const PatientHomeScreen({super.key, required this.token});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Slot> slots = [
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "09:30", endTime: "10:00", status: "booked"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:00", endTime: "10:30", status: "frozen"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:30", endTime: "11:00", status: "available"),
  ];

  void _bookSlot(Slot slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Booking"),
        content: Text("Book this slot?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                slot.status = "booked";
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking Successful. Try to reach 10 mins earlier than your time")),
              );
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = slots
        .where((slot) => slot.status == "available")
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
      ),

      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Check out Available Slots",
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 24, 39),
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (BuildContext context, int index) {
                  final slot = availableSlots[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    color: Colors.greenAccent,
                    child: ListTile(
                      title: Text("${slot.startTime} - ${slot.endTime}"),
                      trailing: TextButton(
                        onPressed: () => _bookSlot(slot),
                        child: Text("Tap to Book"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
