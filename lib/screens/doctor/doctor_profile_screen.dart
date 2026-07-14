
import 'package:doc_appoint_frontend/providers/doctor_profile_provider.dart';
import 'package:doc_appoint_frontend/screens/common/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  Future<void> completeAppointment(
    BuildContext context,
    WidgetRef ref,
    int appointmentId,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Complete Appointment?"),
        content: const Text("Mark this appointment as completed?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final status = await ref
                  .read(doctorProfileProvider.notifier)
                  .completeAppointment(appointmentId);
              if (!context.mounted) return;
              if (status == 200) {
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

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout?"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(doctorProfileProvider.notifier).logout();
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProfileProvider);
    ref.listen(doctorProfileProvider, (previous, next) async {
      if (next.error == "session_expired") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Oops! Seems like your session expired. Please login again.",
            ),
          ),
        );
        await ref.read(doctorProfileProvider.notifier).logout();

        if (!context.mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          "/",
          (_) => false,
        );
      }
    });
    return ProfileScreen(
      user: state.user,
      appointments: state.appointments,
      isLoading: state.isLoading,
      onLogout: ()=> logout(context, ref),
      title: "Doctor Profile",
      onCancelOrCompleteAppointment: (id)=> completeAppointment(context, ref, id),
    );
  }
}
