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

