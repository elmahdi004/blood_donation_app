import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class BloodRequestService {
  final SharedPreferences _prefs;

  BloodRequestService(this._prefs);

  Future<List<Map<String, dynamic>>> getUserRequests() async {
    final token = _prefs.getString('token');
    if (token == null) {
      throw Exception('Non authentifié');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/demandes/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print('Decoded data type: ${decodedData.runtimeType}');
        print('Decoded data: $decodedData');

        if (decodedData is List) {
          return List<Map<String, dynamic>>.from(decodedData);
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          return List<Map<String, dynamic>>.from(decodedData['data']);
        } else {
          print('Unexpected data format: $decodedData');
          return [];
        }
      } else {
        throw Exception(
            'Erreur lors de la récupération des demandes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserRequests: $e');
      throw Exception('Erreur lors de la récupération des demandes: $e');
    }
  }

  Future<void> requestBloodDonation({
    required String groupeSanguin,
    required bool urgent,
    required int quantite,
    required String ville,
    required String nomHopital,
    String? message,
  }) async {
    try {
      final token = _prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/blood-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'groupe_sanguin': groupeSanguin,
          'urgent': urgent,
          'quantite': quantite,
          'ville': ville,
          'nom_hopital': nomHopital,
          'message': message,
        }),
      );

      if (response.statusCode != 201) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to create blood request');
      }
    } catch (e) {
      print('Error creating blood request: $e');
      throw Exception('Failed to create blood request: ${e.toString()}');
    }
  }
}
