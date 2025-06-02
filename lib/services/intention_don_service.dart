import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IntentionDonService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final SharedPreferences _prefs;

  IntentionDonService(this._prefs);

  Future<List<Map<String, dynamic>>> getUserIntentions() async {
    final userId = _prefs.getInt('user_id');
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/intentions-de-dons'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.getString('token')}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load intentions de dons');
    }
  }

  Future<Map<String, dynamic>> createIntentionDon({
    required String groupeSanguin,
    required DateTime dateDisponibilite,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/intentions-de-dons'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_prefs.getString('token')}',
      },
      body: json.encode({
        'groupe_sanguin': groupeSanguin,
        'date_disponibilite': dateDisponibilite.toIso8601String().split('T')[0],
        'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to create intention de don');
    }
  }

  Future<void> deleteIntentionDon(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/intentions-de-dons/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.getString('token')}',
      },
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to delete intention de don');
    }
  }
}
