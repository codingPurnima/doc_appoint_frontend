import 'package:doc_appoint_frontend/models/slot.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  List<Slot> slots = [
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "09:30", endTime: "10:00", status: "booked"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:00", endTime: "10:30", status: "frozen"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:30", endTime: "11:00", status: "available"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:00", endTime: "10:30", status: "frozen"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
    Slot(startTime: "10:00", endTime: "10:30", status: "frozen"),
    Slot(startTime: "09:00", endTime: "09:30", status: "available"),
  ];
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "Check out your Slots",
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 24, 39),
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  final status = slots[index].status;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 5,
                    ),
                    color: (status=="available")? Colors.green 
                    : (status=="booked")? Colors.redAccent
                    : (status=="frozen")? Colors.blueGrey
                    : Colors.lightBlue,
                    child: ListTile(
                      title: Text("${slot.startTime} - ${slot.endTime}", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Text("Status: $status", style: TextStyle(fontSize: 15, color: Colors.white),),
                      onTap: (){

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Create slots",
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 6, 24, 39),
        child: Icon(Icons.create, size: 45),
      ),
    );
  }
}
