import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform, SocketException;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use different base URLs for different platforms
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:8000/api'; // iOS simulator
    } else {
      return 'http://127.0.0.1:8000/api'; // Web/Desktop
    }
  }

  final _storage = SharedPreferences.getInstance();

  // Get auth token
  Future<String?> getToken() async {
    final prefs = await _storage;
    return prefs.getString('token');
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
        // Store token and user data
        final prefs = await _storage;
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));
        return data;
      } else {
        // Handle validation errors from Laravel
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
      // Clear local storage regardless of API call success
      final prefs = await _storage;
      await prefs.clear();
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
