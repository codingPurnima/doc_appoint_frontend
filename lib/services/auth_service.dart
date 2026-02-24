import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static String? _token;
  final String baseUrl = ApiService.baseUrl;

  Future<bool> register(String username, String phone, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "phone": phone,
        "password": password,
      }),
    );

    return response.statusCode == 201;
  }

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["access_token"];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      AuthService.setToken(token);
      return token;
    }

    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  static void setToken(String token) {
    _token = token;
  }

  static String? get token => _token;
}
