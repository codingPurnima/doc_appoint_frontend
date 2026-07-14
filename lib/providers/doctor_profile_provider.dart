import 'dart:convert';

import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorProfileState {
  final Map<String, dynamic>? user;
  final List<dynamic> appointments;
  final bool isLoading;
  final String? error;

  const DoctorProfileState({
    required this.user,
    required this.appointments,
    required this.isLoading,
    required this.error,
  });

  DoctorProfileState copyWith({
    Map<String, dynamic>? user,
    List<dynamic>? appointments = const [],
    bool? isLoading = true,
    String? error,
  }) {
    return DoctorProfileState(
      user: user ?? this.user,
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DoctorProfileNotifier extends Notifier<DoctorProfileState> {
  final ApiService api = ApiService();

  @override
  DoctorProfileState build() {
    fetchProfileData();
    return const DoctorProfileState(
      user: null,
      appointments: [],
      isLoading: true,
      error: null,
    );
  }

  Future<void> fetchProfileData() async {
    state = state.copyWith(isLoading: true);
    try {
      final userResponse = await api.getRequest("/users/me");
      final appointmentResponse = await api.getRequest("/appointments/doctor");

      if (userResponse.statusCode == 200 &&
          appointmentResponse.statusCode == 200) {
        state = state.copyWith(
          user: jsonDecode(userResponse.body),
          appointments: jsonDecode(appointmentResponse.body),
          isLoading: false,
        );
      } else if (userResponse.statusCode == 401) {
        state = state.copyWith(isLoading: false, error: "session_expired");
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<int> completeAppointment(int id) async {
    final response = await api.patchRequest("/appointments/$id/complete", {});
    if (response.statusCode == 200) {
      await fetchProfileData();
    }
    return response.statusCode;
  }

  Future<void> logout() async {
    await AuthService().logout();
  }
}

final doctorProfileProvider =
    NotifierProvider<DoctorProfileNotifier, DoctorProfileState>(
      DoctorProfileNotifier.new,
    );
