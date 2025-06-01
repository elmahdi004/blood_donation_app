import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class BloodBankService {
  final SharedPreferences _prefs;

  BloodBankService(this._prefs);

  Future<String?> _getToken() async {
    return _prefs.getString('token');
  }

  // Get all blood banks with their locations
  Future<List<Map<String, dynamic>>> getBloodBanks() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      print('Fetching blood banks with token: ${token.substring(0, 10)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/blood-banks'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((bank) => Map<String, dynamic>.from(bank)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Forbidden: You do not have permission to access this resource');
      } else {
        throw Exception('Failed to fetch blood banks: ${response.body}');
      }
    } catch (e) {
      print('Error fetching blood banks: $e');
      throw Exception('Failed to fetch blood banks: ${e.toString()}');
    }
  }

  // Get blood bank details by ID
  Future<Map<String, dynamic>> getBloodBankDetails(int id) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/blood-banks/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Forbidden: You do not have permission to access this resource');
      } else {
        throw Exception('Failed to fetch blood bank details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching blood bank details: $e');
      throw Exception('Failed to fetch blood bank details: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getBloodBankStocks(int bloodBankId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/blood-banks/$bloodBankId/stocks'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Forbidden: You do not have permission to access this resource');
      } else {
        throw Exception('Failed to fetch blood bank stocks: ${response.body}');
      }
    } catch (e) {
      print('Error fetching blood bank stocks: $e');
      throw Exception('Failed to fetch blood bank stocks: ${e.toString()}');
    }
  }
}
