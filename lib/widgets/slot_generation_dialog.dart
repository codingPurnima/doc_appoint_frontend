import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'dart:convert';

class GenerateSlotsDialog extends StatefulWidget {
  final VoidCallback onSlotsGenerated;

  const GenerateSlotsDialog({super.key, required this.onSlotsGenerated});

  @override
  State<GenerateSlotsDialog> createState() => _GenerateSlotsDialogState();
}

class _GenerateSlotsDialogState extends State<GenerateSlotsDialog> {
  final startController = TextEditingController(text: "09:00");
  final endController = TextEditingController(text: "17:00");
  final durationController = TextEditingController(text: "30");
  final breakStartController = TextEditingController();
  final breakEndController = TextEditingController();

  bool _isSubmitting = false;

  DateTime _startDate = DateUtils.dateOnly(DateTime.now());
  int _durationDays = 7;
  bool _weekdaysOnly = false;

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    durationController.dispose();
    breakStartController.dispose();
    breakEndController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _pickStartDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final selected = await showDatePicker(
      context: context,
      initialDate: _startDate.isBefore(today) ? today : _startDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (selected != null && mounted) {
      setState(() {
        _startDate = DateUtils.dateOnly(selected);
      });
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final parts = controller.text.trim().split(':');

    final initialTime = parts.length == 2
        ? TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 9,
            minute: int.tryParse(parts[1]) ?? 0,
          )
        : const TimeOfDay(hour: 9, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'SELECT TIME',
    );

    if (picked != null && mounted) {
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    final duration = int.tryParse(durationController.text.trim());
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid slot duration in minutes"),
        ),
      );
      return;
    }

    if (startController.text.trim().isEmpty ||
        endController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Start and End times are required")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final breaks =
        breakStartController.text.trim().isNotEmpty &&
            breakEndController.text.trim().isNotEmpty
        ? [
            {
              "start": breakStartController.text.trim(),
              "end": breakEndController.text.trim(),
            },
          ]
        : <Map<String, String>>[];

    final response = await ApiService().postRequest("/slots/generate-range", {
      "start_date": _formatDate(_startDate),
      "duration_days": _durationDays,
      "weekdays_only": _weekdaysOnly,
      "day_start": startController.text.trim(),
      "day_end": endController.text.trim(),
      "slot_duration_minutes": duration,
      "breaks": breaks,
    });
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data["results"] as List<dynamic>;

      final created = data["total_slots_created"] as int;
      final skipped = results
          .where((item) => item["status"] == "skipped")
          .length;

      widget.onSlotsGenerated();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Created $created slots. $skipped date(s) skipped."),
        ),
      );
    } else {
      final message = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Slot generation failed: $message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      title: const Row(
        children: [
          Icon(Icons.more_time_rounded, color: AppColors.primary, size: 24),
          SizedBox(width: 10),
          Text("Generate Slots"),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configure your daily consultation slots",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              const Text(
                "Start Date",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _isSubmitting ? null : _pickStartDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(_formatDate(_startDate)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _durationDays,
                decoration: const InputDecoration(labelText: "Generate for"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("One day")),
                  DropdownMenuItem(value: 3, child: Text("3 days")),
                  DropdownMenuItem(value: 7, child: Text("7 days")),
                  DropdownMenuItem(value: 14, child: Text("14 days")),
                ],
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _durationDays = value);
                        }
                      },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Weekdays only"),
                subtitle: const Text("Skip Saturdays and Sundays"),
                value: _weekdaysOnly,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() => _weekdaysOnly = value);
                      },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startController,
                      readOnly: true,
                      onTap: () => _pickTime(startController),
                      decoration: const InputDecoration(
                        labelText: "Start Time",
                        suffixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: endController,
                      readOnly: true,
                      onTap: () => _pickTime(endController),
                      decoration: const InputDecoration(
                        labelText: "End Time",
                        suffixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Slot Duration (minutes)",
                  hintText: "30",
                  suffixText: "min",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Break Time (Optional)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: breakStartController,
                      readOnly: true,
                      onTap: ()=> _pickTime(breakStartController),
                      decoration: const InputDecoration(
                        labelText: "Break Start",
                        suffixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: breakEndController,
                      readOnly: true,
                      onTap: ()=> _pickTime(breakEndController),
                      decoration: const InputDecoration(
                        labelText: "Break End",
                        suffixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(110, 40)),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text("Generate"),
        ),
      ],
    );
  }
}
