import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeService();
    initializeDateFormatting('fr_FR', null);
  }

  Future<void> _initializeService() async {
    _prefs = await SharedPreferences.getInstance();
    _appointmentService = AppointmentService(_prefs);
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: mainColor,
        title: const Text(
          'Prendre un rendez-vous',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
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
                                    : () => _showConfirmationModal(slot),
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

  void _showConfirmationModal(Map<String, dynamic> slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Confirmer le rendez-vous',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.location_on,
                    'Centre de don',
                    widget.bloodBank['name'],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                        .format(_selectedDay),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.access_time,
                    'Horaire',
                    '${_formatTime(slot['start_time'])} - ${_formatTime(slot['end_time'])}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _bookAppointment(slot);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirmer',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: mainColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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
      setState(() => _isLoading = true);

      final userId = _prefs.getInt('user_id');
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Veuillez vous connecter pour prendre un rendez-vous'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // Return to previous screen
        return;
      }

      await _appointmentService.bookAppointment(
        widget.bloodBank['id'],
        slot['slot_id'],
        _selectedDay,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rendez-vous réservé avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the slots list
      _loadAvailableSlots(_selectedDay);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la réservation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
