import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/blood_bank_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';
import '../constants.dart';
import './../env.dart';
import './appointment_booking_page.dart';

class BloodBanksMapPage extends StatefulWidget {
  const BloodBanksMapPage({Key? key}) : super(key: key);

  @override
  State<BloodBanksMapPage> createState() => _BloodBanksMapPageState();
}

class _BloodBanksMapPageState extends State<BloodBanksMapPage> {
  List<Map<String, dynamic>> bloodBanks = [];
  bool isLoading = true;
  String? errorMessage;
  late BloodBankService _bloodBankService;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _bloodBankService = BloodBankService(prefs);
    await _loadBloodBanks();
  }

  Future<void> _loadBloodBanks() async {
    try {
      final banks = await _bloodBankService.getBloodBanks();
      setState(() {
        bloodBanks = banks;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });

      if (e.toString().contains('Unauthorized') ||
          e.toString().contains('Forbidden')) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showBloodBankDetails(Map<String, dynamic> bank) async {
    try {
      final stocks = await _bloodBankService.getBloodBankStocks(bank['id']);

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital,
                        color: Colors.white, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bank['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bank['address'] ?? 'No address available',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Blood Stock Levels',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          _buildBloodGroupCard('A+', stocks['A+'] ?? 0),
                          _buildBloodGroupCard('A-', stocks['A-'] ?? 0),
                          _buildBloodGroupCard('B+', stocks['B+'] ?? 0),
                          _buildBloodGroupCard('B-', stocks['B-'] ?? 0),
                          _buildBloodGroupCard('AB+', stocks['AB+'] ?? 0),
                          _buildBloodGroupCard('AB-', stocks['AB-'] ?? 0),
                          _buildBloodGroupCard('O+', stocks['O+'] ?? 0),
                          _buildBloodGroupCard('O-', stocks['O-'] ?? 0),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildContactInfo(
                          Icons.phone, bank['phone'] ?? 'Not available'),
                      const SizedBox(height: 8),
                      _buildContactInfo(
                          Icons.email, bank['email'] ?? 'Not available'),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentBookingPage(
                                  bloodBank: bank,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Prendre un rendez-vous',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading blood bank stocks: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBloodGroupCard(String group, int stock) {
    Color stockColor;
    if (stock <= 0) {
      stockColor = Colors.red;
    } else if (stock < 5) {
      stockColor = Colors.orange;
    } else {
      stockColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            group,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stock.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: stockColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'units',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: mainColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Banks Map'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBloodBanks,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(
                        32.30859338, -9.15282397), // Algiers coordinates
                    initialZoom: 11.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.blood_donation_app',
                      additionalOptions: {
                        'accessToken': mapboxAccessToken,
                      },
                    ),
                    MarkerLayer(
                      markers: bloodBanks.map((bank) {
                        return Marker(
                          point: LatLng(
                            double.parse(bank['latitude'].toString()),
                            double.parse(bank['longitude'].toString()),
                          ),
                          width: 120,
                          height: 120,
                          child: GestureDetector(
                            onTap: () => _showBloodBankDetails(bank),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: mainColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.local_hospital,
                                          color: mainColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          bank['name'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 0,
                                  height: 0,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.transparent,
                                        width: 8,
                                      ),
                                      right: BorderSide(
                                        color: Colors.transparent,
                                        width: 8,
                                      ),
                                      top: BorderSide(
                                        color: Colors.white,
                                        width: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
    );
  }
}
