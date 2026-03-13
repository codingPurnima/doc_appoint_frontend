import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _role;
  final String baseUrl = ApiService.baseUrl;
  static bool get isLoggedIn => _accessToken != null;

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString("access_token");
    _refreshToken = prefs.getString("refresh_token");
    _role = prefs.getString("role");
  }

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

  Future<bool> registerDoctor(
    String username,
    String phone,
    String password,
    String secret,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/doctor?secret=$secret"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "phone": phone,
        "password": password,
      }),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, String>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final accessToken = data["access_token"];
      final refreshToken = data["refresh_token"];
      final role = data["role"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", accessToken);
      await prefs.setString("refresh_token", refreshToken);
      await prefs.setString("role", role);

      _accessToken = accessToken;
      _refreshToken = refreshToken;
      _role = role;

      return {"access_token": accessToken, "role": role};
    }

    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("access_token");
    await prefs.remove("refresh_token");

    _accessToken = null;
    _refreshToken = null;
  }

  Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refresh_token");

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/auth/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refresh_token": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data["access_token"];

      await prefs.setString("access_token", newAccessToken);
      _accessToken = newAccessToken;

      return newAccessToken;
    }

    return null;
  }

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static String? get role => _role;
}
