import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:doc_appoint_frontend/theme/app_theme.dart';
import 'package:doc_appoint_frontend/widgets/empty_state_view.dart';
import 'package:doc_appoint_frontend/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import '../../models/slot.dart';
import '../../models/doctor_profile.dart';
import '../../widgets/doctor_info_row.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  void initState() {
    super.initState();
    // _razorpayService = RazorpayService(
    //   baseUrl: AppConfig.baseUrl,
    //   getToken: () => _storage.read(key: 'access_token'),
    // );

    // _razorpayService.initialize();
    // _razorpayService.onMessage = (message) {
    //   if (!mounted) return;

    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text(message)));
    // };

    // _razorpayService.onPaymentVerified = (appointmentId) {
    //   // Refresh appointments or reload patient home data here.
    //   fetchSlots();
    // };
    fetchSlots();
  }

  // final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // late final RazorpayService _razorpayService;

  List<Slot> slots = [];
  bool isLoading = true;

  DoctorProfile? _doctorProfile;
  bool _isDoctorProfileLoading = false;
  String? _doctorProfileError;

  Future<void> fetchSlots() async {
    final apiService = ApiService();
    final today = DateTime.now().toIso8601String().split("T")[0];

    final result = await apiService.getAvailableSlots(today);

    if (!mounted) return;

    if (result != null) {
      setState(() {
        slots = result.map((json) => Slot.fromJson(json)).toList();
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
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.event_available, color: AppColors.primary),
            SizedBox(width: 10),
            Text("Confirm Booking"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Would you like to book this appointment slot?",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 18, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    "${slot.startTime} - ${slot.endTime}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42)),
            onPressed: () async {
              Navigator.pop(dialogContext);

              try {
                final success = await ApiService().bookAppointment(slot.id);

                if (!mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Appointment booked successfully. Please pay at the clinic.',
                      ),
                    ),
                  );

                  await fetchSlots();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Booking failed. The slot may no longer be available.',
                      ),
                    ),
                  );

                  await fetchSlots();
                }
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Unable to complete booking. Please try again.',
                    ),
                  ),
                );
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<void> _showDoctorProfile() async {
    if (_doctorProfile != null) {
      _openDoctorProfileDialog();
      return;
    }

    setState(() {
      _isDoctorProfileLoading = true;
      _doctorProfileError = null;
    });

    try {
      // Replace with the actual users.id of your demo doctor.
      final profile = await ApiService().getDoctorProfile(2);

      if (!mounted) return;

      setState(() {
        _doctorProfile = profile;
        _isDoctorProfileLoading = false;
      });

      _openDoctorProfileDialog();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _doctorProfileError = e.toString();
        _isDoctorProfileLoading = false;
      });

      _openDoctorProfileDialog();
    }
  }

  void _openDoctorProfileDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        if (_isDoctorProfileLoading) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Loading doctor profile..."),
              ],
            ),
          );
        }

        final doctor = _doctorProfile;

        if (doctor == null) {
          return AlertDialog(
            title: const Text("Doctor Information"),
            content: Text(_doctorProfileError ?? "Doctor profile unavailable."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Close"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showDoctorProfile();
                },
                child: const Text("Retry"),
              ),
            ],
          );
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),

          title: Row(
            children: [
              const Expanded(
                child: Text(
                  "Doctor Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Doctor identity
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child:
                              (doctor.profileImageUrl?.trim().isNotEmpty ??
                                  false)
                              ? ClipOval(
                                  child: Image.network(
                                    doctor.profileImageUrl!.trim(),
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.medical_services_outlined,
                                        size: 28,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.medical_services_outlined,
                                  size: 28,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.fullName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctor.specialization,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Professional details
                  const Text(
                    "Professional Details",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  DoctorInfoRow(
                    icon: Icons.school_outlined,
                    label: "Qualification",
                    value: doctor.qualification,
                  ),
                  DoctorInfoRow(
                    icon: Icons.work_outline,
                    label: "Experience",
                    value: "${doctor.experienceYears} years",
                  ),

                  const SizedBox(height: 18),

                  // Clinic details
                  const Text(
                    "Clinic Information",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  DoctorInfoRow(
                    icon: Icons.local_hospital_outlined,
                    label: "Clinic",
                    value: doctor.clinicName,
                  ),
                  DoctorInfoRow(
                    icon: Icons.location_on_outlined,
                    label: "Address",
                    value: doctor.clinicAddress,
                  ),

                  if (doctor.bio?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 18),
                    const Text(
                      "About the Doctor",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      doctor.bio!.trim(),
                      style: TextStyle(
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Consultation fee
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Icon(
                        //   Icons.currency_rupee,
                        //   color: Theme.of(context).colorScheme.primary,
                        // ),
                        // const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Consultation Fee   ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "₹${doctor.consultationFee}",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("View availability"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = slots
        .where((slot) => slot.status == "available" && !slot.isExpired)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Welcome!")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Available Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Today's Open Consultations",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.availableBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.availableBorder),
                  ),
                  child: Text(
                    "${availableSlots.length} Open",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.availableText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          "Loading available slots...",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : availableSlots.isEmpty
                ? const EmptyStateView(
                    icon: Icons.event_busy_outlined,
                    title: "No slots available today",
                    subtitle:
                        "Please check back later for newly released openings.",
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    itemCount: availableSlots.length,
                    itemBuilder: (BuildContext context, int index) {
                      final slot = availableSlots[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.schedule_outlined,
                                color: AppColors.accent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${slot.startTime} - ${slot.endTime}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const StatusBadge(status: "available"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _bookSlot(slot),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(88, 38),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text("Book"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDoctorProfile,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        tooltip: "Doctor Information",
        child: const Icon(Icons.medical_information_outlined),
      ),
    );
  }
}
