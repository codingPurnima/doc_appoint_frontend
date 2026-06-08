import 'dart:convert';

import 'package:doc_appoint_frontend/models/slot.dart';
import 'package:doc_appoint_frontend/services/api_service.dart';
import 'package:doc_appoint_frontend/widgets/slot_generation_dialog.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  List<Slot> slots = [];
  bool isLoading = true;
  final api = ApiService();

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  Future<void> fetchSlots() async {
    final today = DateTime.now().toIso8601String().split("T")[0];
    final response = await api.getRequest("/slots?date=$today");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          slots = data.map((json) => Slot.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          legendItem("Available", const Color(0xFF4CAF7A)),
          legendItem("Booked", const Color(0xFFE57373)),
          legendItem("Frozen", const Color(0xFFB0BEC5)),
          legendItem("Completed", const Color(0xFF5C9ED8)),
        ],
      ),
    );
  }

  Widget legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 15, height: 15, color: color),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            buildLegend(),
            Container(
              height: 50,
              alignment: Alignment.center,
              color: Color(0xFFDCE6F1),
              child: Text(
                "Check out your Slots",
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 24, 39),
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (slots.isEmpty)
              const Center(child: Text("No slots generated yet"))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    final status = slots[index].status;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 5,
                      ),
                      color: (status == "available")
                          ? const Color(0xFF4CAF7A)
                          : (status == "booked")
                          ? const Color(0xFFE57373)
                          : (status == "frozen")
                          ? const Color(0xFFB0BEC5)
                          : const Color(0xFF5C9ED8),
                      child: ListTile(
                        title: Text(
                          "${slot.startTime} - ${slot.endTime}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Status: $status",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        onTap: () async {
                          if (slot.status == 'booked') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Can not freeze booked slot"),
                              ),
                            );
                          } else if (slot.status == "available" ||
                              slot.status == "frozen") {
                            try {
                              await api.toggleFreezeSlot(slot.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Slot updated")),
                              );
                              fetchSlots();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error updating slot")),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                GenerateSlotsDialog(onSlotsGenerated: fetchSlots),
          );
        },
        tooltip: "Create slots",
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 6, 24, 39),
        child: Icon(Icons.add, size: 45),
      ),
      backgroundColor: Color(0xFFDCE6F1),
    );
  }
}
