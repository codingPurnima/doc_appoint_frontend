import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/slot.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  List<Slot> slots = [];
  bool isLoading = true;

  Future<void> fetchSlots() async {
    final apiService = ApiService();

    final today = DateTime.now().toIso8601String().split("T")[0];

    final result = await apiService.getAvailableSlots(today);

    if (result != null) {
      setState(() {
        slots = result.map<Slot>((json) => Slot.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _bookSlot(Slot slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.event_available, color: Color(0xFF061827)),
            SizedBox(width: 8),
            Text("Confirm Booking"),
          ],
        ),

        content: Text("Book this slot?"),
        backgroundColor: const Color(0xFFF7FAFC),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ApiService().bookAppointment(slot.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color.fromARGB(255, 15, 50, 79),
                    // behavior: SnackBarBehavior.floating,
                    content: Text(
                      "Booking Successful. Try to reach 10 mins earlier than your time",
                    ),
                  ),
                );
                fetchSlots();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Booking Failed")));
              }
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // SOON
  // void _buildDoctorDialog(BuildContext context) {

  // }

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
              color: Color(0xFFDCE6F1),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  " Check out Available Slots ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 6, 24, 39),
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (slots.isEmpty)
              const Center(child: Text("No slots available today"))
            else
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
                      color: const Color(0xFF0E2A47),
                      child: ListTile(
                        title: Text(
                          "${slot.startTime} - ${slot.endTime}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        trailing: TextButton(
                          onPressed: () => _bookSlot(slot),
                          child: Text(
                            "Tap to Book",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text("This is your doctor")),
          );
        },
        backgroundColor: Color(0xFFDCE6F1),
        foregroundColor: Color.fromARGB(255, 6, 24, 39),
        child: Icon(Icons.medical_information),
      ),
      backgroundColor: Color(0xFFDCE6F1),
    );
  }
}
