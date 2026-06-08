class Slot {
  final int id;
  final String startTime;
  final String endTime;
  String status; // "available", "booked", "frozen"

  Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      startTime: json['start_time'] ?? json['startTime'] ?? '',
      endTime: json['end_time'] ?? json['endTime'] ?? '',
      status: json['status'] ?? 'available',
    );
  }
}
