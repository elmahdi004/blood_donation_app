import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AppointmentService {
  final SharedPreferences _prefs;

  AppointmentService(this._prefs);

  Future<String?> _getToken() async {
    return _prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> getAvailableSlots(
    int bloodBankId,
    DateTime date,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
            '$baseUrl/blood-banks/$bloodBankId/slots?date=$formattedDate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((slot) => Map<String, dynamic>.from(slot)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Forbidden: You do not have permission to access this resource');
      } else {
        throw Exception('Failed to fetch available slots: ${response.body}');
      }
    } catch (e) {
      print('Error fetching available slots: $e');
      throw Exception('Failed to fetch available slots: ${e.toString()}');
    }
  }
}
