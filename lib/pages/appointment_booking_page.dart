import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../services/appointment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentBookingPage extends StatefulWidget {
  final Map<String, dynamic> bloodBank;

  const AppointmentBookingPage({
    Key? key,
    required this.bloodBank,
  }) : super(key: key);

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Map<String, dynamic>> _availableSlots = [];
  bool _isLoading = false;
  late AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _appointmentService = AppointmentService(prefs);
    _loadAvailableSlots(_selectedDay);
  }

  String _formatTime(String timeString) {
    // Parse the time string and format it to HH:mm
    final time = TimeOfDay(
      hour: int.parse(timeString.split(':')[0]),
      minute: int.parse(timeString.split(':')[1]),
    );
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prendre un rendez-vous'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: mainColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _loadAvailableSlots(selectedDay);
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _availableSlots.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun créneau disponible pour cette date',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _availableSlots.length,
                        itemBuilder: (context, index) {
                          final slot = _availableSlots[index];
                          final bool isBooked = slot['is_booked'] == 1;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isBooked
                                      ? Colors.grey.withOpacity(0.1)
                                      : mainColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.access_time,
                                  color: isBooked ? Colors.grey : mainColor,
                                ),
                              ),
                              title: Text(
                                '${_formatTime(slot['start_time'])} - ${_formatTime(slot['end_time'])}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isBooked ? Colors.grey : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isBooked ? 'Créneau réservé' : 'Disponible',
                                style: TextStyle(
                                  color: isBooked
                                      ? Colors.grey[600]
                                      : Colors.green[600],
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: isBooked
                                    ? null
                                    : () => _bookAppointment(slot),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isBooked ? Colors.grey : mainColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(isBooked ? 'Réservé' : 'Réserver'),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAvailableSlots(DateTime date) async {
    setState(() {
      _isLoading = true;
      _availableSlots = [];
    });

    try {
      final slots = await _appointmentService.getAvailableSlots(
        widget.bloodBank['id'],
        date,
      );

      setState(() {
        _availableSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading slots: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _bookAppointment(Map<String, dynamic> slot) async {
    try {
      // TODO: Implement API call to book appointment
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rendez-vous réservé avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
