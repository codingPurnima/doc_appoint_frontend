import 'package:flutter/material.dart';
import '../models/slot.dart';

class SlotGenerationDialog extends StatefulWidget {
  final Function(List<Slot>) onSlotsGenerated;

  const SlotGenerationDialog({super.key, required this.onSlotsGenerated});

  @override
  State<SlotGenerationDialog> createState() => _SlotGenerationDialogState();
}

class _SlotGenerationDialogState extends State<SlotGenerationDialog> {

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final TextEditingController durationController = TextEditingController();

  Future<void> pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  List<Slot> generateSlots() {
    List<Slot> slots = [];

    if (startTime == null || endTime == null) return slots;

    int duration = int.tryParse(durationController.text) ?? 0;
    if (duration <= 0) return slots;

    DateTime start = DateTime(
      0,
      0,
      0,
      startTime!.hour,
      startTime!.minute,
    );

    DateTime end = DateTime(
      0,
      0,
      0,
      endTime!.hour,
      endTime!.minute,
    );

    while (start.add(Duration(minutes: duration)).isBefore(end) ||
        start.add(Duration(minutes: duration)).isAtSameMomentAs(end)) {

      DateTime slotEnd = start.add(Duration(minutes: duration));

      String timeLabel =
          "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - "
          "${slotEnd.hour.toString().padLeft(2, '0')}:${slotEnd.minute.toString().padLeft(2, '0')}";

      slots.add(Slot(startTime: timeLabel, endTime:timeLabel, status: "available"));

      start = slotEnd;
    }

    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Generate Slots"),
      content: SingleChildScrollView(
        child: Column(
          children: [

            ElevatedButton(
              onPressed: () => pickTime(true),
              child: Text(
                startTime == null
                    ? "Select Start Time"
                    : "Start: ${startTime!.format(context)}",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => pickTime(false),
              child: Text(
                endTime == null
                    ? "Select End Time"
                    : "End: ${endTime!.format(context)}",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Slot Duration (minutes)",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            List<Slot> slots = generateSlots();
            widget.onSlotsGenerated(slots);
            Navigator.pop(context);
          },
          child: const Text("Generate"),
        ),
      ],
    );
  }
}
                                            