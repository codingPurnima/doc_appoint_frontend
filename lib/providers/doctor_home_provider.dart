import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/slot.dart';
import '../services/api_service.dart';

class DoctorHomeState {
  final List<Slot> slots;
  final bool isLoading;
  final String? error;

  const DoctorHomeState({
    required this.slots,
    required this.isLoading,
    required this.error,
  });

  DoctorHomeState copyWith({
    List<Slot>? slots,
    bool? isLoading,
    String? error,
  }) {
    return DoctorHomeState(
      slots: slots ?? this.slots,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DoctorHomeNotifier extends Notifier<DoctorHomeState> {
  final ApiService api = ApiService();

  // the initial state of the notifier
  @override
  DoctorHomeState build() {
    return const DoctorHomeState(slots: [], isLoading: true, error: null);
  }

Future<void> fetchSlots({DateTime? date}) async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    final selectedDate = date ?? DateTime.now();
    final formattedDate =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    final response = await api.getRequest(
      "/slots?date=$formattedDate",
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        final newSlots = data
            .map((json) => Slot.fromJson(json))
            .toList();

        state = state.copyWith(
          slots: newSlots,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Unexpected response",
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to fetch slots",
      );
    }
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: e.toString(),
    );
  }
}

  Future<void> toggleFreezeSlot(int id) async {
    await api.toggleFreezeSlot(id);
    await fetchSlots();
  }
}

final doctorHomeProvider =
    NotifierProvider<DoctorHomeNotifier, DoctorHomeState>(
      DoctorHomeNotifier.new,
    );