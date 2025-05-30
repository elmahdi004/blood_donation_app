import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show SocketException;
import '../constants.dart';

class AuthService {
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  // Get auth token
  Future<String?> getToken() async {
    return _prefs.getString('token');
  }

  // Login user
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _prefs.setString('token', data['token']);
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Mobile Login
  Future<Map<String, dynamic>> mobileLogin(
      String email, String password) async {
    try {
      print('Attempting to login with email: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/mobile/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        await _prefs.setString('token', data['token']);
        await _prefs.setString('user', json.encode(data['user']));
        return data;
      } else {
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first.first;
          throw Exception(firstError);
        }
        throw Exception(data['message'] ?? 'Login failed');
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      throw Exception(
          'Cannot connect to server. Please check your internet connection and try again.');
    } on FormatException catch (e) {
      print('Format Exception: $e');
      print('Response that caused the error: ${e.source}');
      throw Exception('Invalid response from server. Please try again.');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } finally {
      await _prefs.clear();
    }
  }

  // Get authenticated user
  Future<Map<String, dynamic>> getAuthenticatedUser() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
