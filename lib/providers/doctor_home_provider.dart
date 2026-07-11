import 'dart:convert';
import 'package:flutter/services.dart';
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