import 'dart:convert';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
// import '../models/slot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<http.Response> getRequest(String endpoint) async {
    final token = await getToken();

    return http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await getToken();

    return http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  Future<List<dynamic>?> getAvailableSlots(String date) async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/slots/available?date=$date"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<bool> bookAppointment(int slotId) async {
    final token = await getToken();
    if (token == null) {
      return false;
    }
    final response = await http.post(
      Uri.parse("$baseUrl/appointments/book"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"slot_id": slotId}),
    );

    return response.statusCode == 201;
  }
}
