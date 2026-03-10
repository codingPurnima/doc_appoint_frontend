import 'dart:convert';

import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Map<String, dynamic>? user;
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final api = ApiService();
    final userResponse = await api.getRequest("/users/me");
    final appointmentResponse = await api.getRequest("/appointments/me");

    if (userResponse.statusCode == 200 &&
        appointmentResponse.statusCode == 200) {
      setState(() {
        user = jsonDecode(userResponse.body);
        appointments = jsonDecode(appointmentResponse.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final response = await ApiService().putRequest(
      "/appointments/$appointmentId/cancel",
      {},
    );

    if (response.statusCode == 200) {
      fetchProfileData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Appointment cancelled")));
    }
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout?"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
            child: Text("Yes"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Color(0xFFDCE6F1),
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
            iconSize: 35,
            color: Colors.white,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Username: ${user?["name"] ?? ""}",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Phone: ${user?["phone"] ?? ""}",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your Appointments",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
              child: appointments.isEmpty
                  ? const Center(child: Text("No appointments yet"))
                  : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                "${appointment["date"]} | ${appointment["start_time"]} - ${appointment["end_time"]}"),
                            subtitle: Text("Status: ${appointment["status"]}"),
                            trailing: appointment["status"] == "booked"
                                ? TextButton(
                                    onPressed: () =>
                                        cancelAppointment(appointment["appointment_id"]),
                                    child: const Text("Cancel"),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
