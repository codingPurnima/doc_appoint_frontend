
class Slot {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  String status;

  Slot({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      date: json['date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ??
          json['startTime']?.toString() ?? '',
      endTime: json['end_time']?.toString() ??
          json['endTime']?.toString() ?? '',
      status: json['status']?.toString() ?? 'available',
    );
  }

  DateTime? _parseSlotDateTime(String time) {
    if (date.isEmpty || time.trim().isEmpty) {
      return null;
    }

    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) {
      return null;
    }

    final parts = time.trim().split(':');
    if (parts.length < 2 || parts.length > 3) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = parts.length == 3 ? int.tryParse(parts[2]) : 0;

    if (hour == null ||
        minute == null ||
        second == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        second < 0 ||
        second > 59) {
      return null;
    }

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      hour,
      minute,
      second,
    );
  }

  bool get isExpired {
    final now = DateTime.now();
    final start = _parseSlotDateTime(startTime);
    final end = _parseSlotDateTime(endTime);

    if (start != null) {
      return !now.isBefore(start);
    }

    if (end != null) {
      return !now.isBefore(end);
    }

    // If the date or time cannot be parsed, don't incorrectly
    // mark the slot as expired.
    return false;
  }
}
