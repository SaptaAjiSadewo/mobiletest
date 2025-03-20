import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://kien ip e ira:8000/api";

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Login gagal. Periksa email dan password!"};
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email,
      String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("Error: $e");
      return {"error": "Terjadi kesalahan"};
    }
  }

  static Future<Map<String, dynamic>?> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Gagal logout"};
      }
    } catch (e) {
      return {"error": "Terjadi kesalahan: $e"};
    }
  }
}
