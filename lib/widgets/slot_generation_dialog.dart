import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GenerateSlotsDialog extends StatefulWidget {
  final VoidCallback onSlotsGenerated;

  const GenerateSlotsDialog({super.key, required this.onSlotsGenerated});

  @override
  State<GenerateSlotsDialog> createState() => _GenerateSlotsDialogState();
}

class _GenerateSlotsDialogState extends State<GenerateSlotsDialog> {
  final startController = TextEditingController();
  final endController = TextEditingController();

  final durationController = TextEditingController();
  final breakStartController = TextEditingController();
  final breakEndController = TextEditingController();

  Future<void> generateSlots({
    required List<Map<String, String>> breaks,
    required int slotDuration,
  }) async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final response = await ApiService().postRequest("/slots/generate", {
      "date": today,
      "day_start": startController.text,
      "day_end": endController.text,
      "slot_duration_minutes": slotDuration,
      "breaks": breaks,
    });

    if (response.statusCode == 200) {
      widget.onSlotsGenerated();

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Slots generated successfully")),
        );
      }
    }
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    durationController.dispose();
    breakStartController.dispose();
    breakEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Generate Slots"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: startController,
            decoration: const InputDecoration(
              labelText: "Start Time",
              hintText: "(09:00)",
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: endController,
            decoration: const InputDecoration(
              labelText: "End Time",
              hintText: "(12:00)",
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: durationController,
            decoration: const InputDecoration(
              labelText: "Duration in minutes",
              hintText: "20",
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: breakStartController,
            decoration: const InputDecoration(
              labelText: " Break Start Time",
              hintText: "(13:00)",
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: breakEndController,
            decoration: const InputDecoration(
              labelText: "Break End Time",
              hintText: "(14:00)",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            generateSlots(
              slotDuration: int.parse(durationController.text),
              breaks:
                  breakStartController.text.isNotEmpty &&
                      breakEndController.text.isNotEmpty
                  ? [
                      {
                        "start": breakStartController.text,
                        "end": breakEndController.text,
                      },
                    ]
                  : [],
            );
          },
          child: const Text("Generate"),
        ),
      ],
    );
  }
}
