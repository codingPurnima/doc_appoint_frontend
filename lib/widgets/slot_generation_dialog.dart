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

  Future<void> generateSlots() async {
    final today = DateTime.now().toIso8601String().split("T")[0];

    final response = await ApiService().postRequest(
      "/slots/generate",
      {
        "date": today,
        "day_start": startController.text,
        "day_end": endController.text,
        "slot_duration_minutes": 30,
        "breaks": []
      },
    );

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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Generate Slots"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: startController,
            decoration: const InputDecoration(labelText: "Start Time (09:00)"),
          ),
          TextField(
            controller: endController,
            decoration: const InputDecoration(labelText: "End Time (12:00)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: generateSlots,
          child: const Text("Generate"),
        ),
      ],
    );
  }
}