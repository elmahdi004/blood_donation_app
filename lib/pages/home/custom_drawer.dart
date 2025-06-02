import 'package:blood_donation_app/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation_app/constants.dart';
import 'package:blood_donation_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_donation_app/pages/blood_banks_map_page.dart';
import 'package:blood_donation_app/pages/appointments_history_page.dart';
import 'package:blood_donation_app/pages/intentions_de_dons_page.dart';
import 'package:blood_donation_app/pages/blood_requests_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final ApiService _apiService;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApiService();
  }

  Future<void> _initializeApiService() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiService = ApiService(prefs);
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _apiService.authService.getAuthenticatedUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _apiService.authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: mainColor,
            ),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          _user?['nom']
                                  ?.toString()
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _user?['nom'] + ' ' + _user?['prenom'] ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _user?['email'] ?? 'user@example.com',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Blood Banks Map'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BloodBanksMapPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('My Appointments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppointmentsHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype_outlined),
            title: const Text('Intentions de Dons'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IntentionsDeDonsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Mes Demandes de Sang'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BloodRequestsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              // Add navigation to settings
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}
