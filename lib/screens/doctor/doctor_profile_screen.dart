import 'dart:convert';

import 'package:doc_appoint_frontend/screens/common/login_screen.dart';
import 'package:doc_appoint_frontend/screens/common/profile_screen.dart';
import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
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
    final appointmentResponse = await api.getRequest("/appointments/doctor");

    if (userResponse.statusCode == 200 &&
        appointmentResponse.statusCode == 200) {
      setState(() {
        user = jsonDecode(userResponse.body);
        appointments = jsonDecode(appointmentResponse.body);
        isLoading = false;
      });
    } else if (userResponse.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Oops! Seems like your session expired. Please login again",
          ),
        ),
      );
      await AuthService().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      return;
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> completeAppointment(int appointmentId) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Complete Appointment?"),
      content: const Text("Mark this appointment as completed?"),
      actions: [
        TextButton(
          onPressed: () async {
            final response = await ApiService().patchRequest(
              "/appointments/$appointmentId/complete",
              {},
            );
            Navigator.pop(context);
            if (response.statusCode == 200) {
              fetchProfileData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Appointment completed")),
              );
            }
          },
          child: const Text("Yes"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("No"),
        ),
      ],
    ),
  );
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
    return ProfileScreen(
      user: user,
      appointments: appointments,
      isLoading: isLoading,
      onLogout: logout,
      title: "Doctor Profile",
      onCancelOrCompleteAppointment: completeAppointment,
    );
  }
}
