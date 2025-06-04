import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_donation_app/constants.dart';

class UserService {
  final SharedPreferences prefs;

  UserService(this.prefs);

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load user data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}
