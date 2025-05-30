import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class BloodRequestService {
  final SharedPreferences _prefs;

  BloodRequestService(this._prefs);

  Future<String?> _getToken() async {
    return _prefs.getString('token');
  }

  // Get blood requests
  Future<List<Map<String, dynamic>>> getBloodRequests() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/blood-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((request) => Map<String, dynamic>.from(request))
            .toList();
      } else {
        throw Exception('Failed to fetch blood requests');
      }
    } catch (e) {
      print('Error fetching blood requests: $e');
      throw Exception('Failed to fetch blood requests: ${e.toString()}');
    }
  }

  // Request blood donation
  Future<void> requestBloodDonation({
    required String groupeSanguin,
    required bool urgent,
    required int quantite,
    required String ville,
    required String nomHopital,
    String? message,
  }) async {
    try {
      print('Starting requestBloodDonation...');
      final token = await _getToken();
      print('Token: ${token != null ? 'Found' : 'Not found'}');
      if (token == null) throw Exception('No token found');

      final requestBody = {
        'groupe_sanguin': groupeSanguin,
        'urgent': urgent ? 1 : 0, // Convert boolean to integer for Laravel
        'quantite': quantite,
        'ville': ville,
        'nom_hopital': nomHopital,
        'message': message,
      };

      print('Sending blood request with data: $requestBody');
      print('URL: $baseUrl/blood-requests');

      final response = await http.post(
        Uri.parse('$baseUrl/blood-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        final data = json.decode(response.body);
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first.first;
          throw Exception(firstError);
        }
        throw Exception(data['message'] ?? 'Failed to create blood request');
      }
    } catch (e) {
      print('Error creating blood request: $e');
      print('Error stack trace: ${StackTrace.current}');
      throw Exception('Failed to create blood request: ${e.toString()}');
    }
  }
}
