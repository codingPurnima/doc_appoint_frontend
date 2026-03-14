import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<http.Response> getRequest(String endpoint) async {
    String? token = await getToken();

    var response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      final authService = AuthService();
      final newToken = await authService.refreshAccessToken();
      if (newToken != null) {
        response = await http.get(
          Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $newToken",
          },
        );
      }
    }
    return response;
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    String? token = await getToken();

    var response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 401) {
      final authService = AuthService();
      final newToken = await authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.post(
          Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $newToken",
          },
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  Future<http.Response> putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    String? token = await getToken();

    var response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      final authService = AuthService();
      final newToken = await authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.put(
          Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $newToken",
          },
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  Future<http.Response> patchRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    String? token = await getToken();

    var response = await http.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 401) {
      final authService = AuthService();
      final newToken = await authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.patch(
          Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $newToken",
          },
          body: jsonEncode(data),
        );
      }
    }

    return response;
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

  Future<void> toggleFreezeSlot(int slotId) async {
    final response = await patchRequest(
      "/slots/$slotId/freeze",
      {},
    );
      if (response.statusCode != 200) {
      throw Exception("Failed to toggle slot freeze");
    }
  }
}
