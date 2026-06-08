import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? user;
  final List<dynamic> appointments;
  final bool isLoading;
  final VoidCallback onLogout;
  final Function(int)? onCancelOrCompleteAppointment;
  final String title;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.appointments,
    required this.isLoading,
    required this.onLogout,
    required this.title,
    this.onCancelOrCompleteAppointment,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDCE6F1),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
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
            children: [
              const SizedBox(height: 10),
              Text("Username: ${user?["name"] ?? ""}"),
              Text("Phone: ${user?["phone"] ?? ""}"),
              const SizedBox(height: 10),

              const Text(
                "Appointments",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
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
                            color: (appointment["status"] == "completed")
                          ? const Color(0xFF4CAF7A)
                          : (appointment["status"] == "cancelled")
                          ? const Color(0xFFE57373)
                          : const Color(0xFF5C9ED8),
                            child: ListTile(
                              title: Text(
                                "${appointment["date"]} | ${appointment["start_time"]} - ${appointment["end_time"]}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Patient: ${appointment["patient_name"]}"),
                                  Text(
                                    "Status: ${appointment["status"]}",
                                  ),
                                ],
                              ),
                              trailing: appointment["status"] == "booked" &&
                                      onCancelOrCompleteAppointment != null
                                  ? TextButton(
                                      onPressed: () => onCancelOrCompleteAppointment?.call(
                                        appointment["appointment_id"],
                                      ),
                                      child: Text(title.contains("Doctor")? "Complete":"Cancel"),
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