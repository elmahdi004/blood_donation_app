import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import '../constants.dart';

class PropositionService {
  final SharedPreferences _prefs;

  PropositionService(this._prefs);

  Future<String?> _getToken() async {
    return _prefs.getString('token');
  }

  // Send proposition for blood request
  Future<void> sendProposition({
    required int requestId,
    required DateTime date,
    required TimeOfDay time,
    String? message,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      // Combine date and time into a single datetime string
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      final requestBody = {
        'demande_id': requestId,
        'date': dateTime
            .toIso8601String()
            .substring(0, 16), // Format: YYYY-MM-DDTHH:mm
        'message': message,
      };

      print('Sending proposition with data: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl/propositions'),
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
        throw Exception(data['message'] ?? 'Failed to send proposition');
      }
    } catch (e) {
      print('Error sending proposition: $e');
      throw Exception('Failed to send proposition: ${e.toString()}');
    }
  }
}
