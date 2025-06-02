import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class AppointmentService {
  final SharedPreferences _prefs;

  AppointmentService(this._prefs);

  String? _getToken() {
    return _prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> getAvailableSlots(
    int bloodBankId,
    DateTime date,
  ) async {
    final token = _getToken();
    if (token == null) throw Exception('Not authenticated');

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await http.get(
      Uri.parse('$baseUrl/blood-banks/$bloodBankId/slots?date=$formattedDate'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Failed to fetch available slots: ${response.body}');
    }
  }

  Future<void> bookAppointment(
      int bloodBankId, int slotId, DateTime date) async {
    final token = _getToken();
    if (token == null) throw Exception('Not authenticated');

    final userId = _prefs.getInt('user_id');
    if (userId == null) throw Exception('User ID not found');

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await http.post(
      Uri.parse('$baseUrl/rendez-vous'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'centre_id': bloodBankId,
        'slot_id': slotId,
        'date': formattedDate,
        'status': 'pending',
      }),
    );

    print('Booking appointment response: ${response.body}');

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Failed to book appointment');
    }
  }

  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    final token = _getToken();
    if (token == null) throw Exception('Not authenticated');

    final userId = _prefs.getInt('user_id');
    if (userId == null) throw Exception('User ID not found');

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/rendez-vous'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Failed to fetch appointments: ${response.body}');
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final token = _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/rendez-vous/$appointmentId/cancel'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden');
    } else if (response.statusCode == 400) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Cannot cancel appointment');
    } else {
      throw Exception('Failed to cancel appointment: ${response.body}');
    }
  }
}
