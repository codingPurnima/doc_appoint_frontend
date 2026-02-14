// class Slot {
//   final int id;
//   final String startTime;
//   final String endTime;

//   Slot({required this.id, required this.startTime, required this.endTime});

//   factory Slot.fromJson(Map<String, dynamic> json) {
//     return Slot(
//       id: json['id'],
//       startTime: json['start_time'],
//       endTime: json['end_time'],
//     );
//   }
// }

class Slot {
  // final int id;
  final String startTime;
  final String endTime;
  String status; // "available", "booked", "frozen"

  Slot({
    // required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
}
