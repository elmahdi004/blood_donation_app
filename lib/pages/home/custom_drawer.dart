import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFDC2E2E),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/women/44.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Farjana Afrin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'farjana622@gmail.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(Icons.person, 'My Profile', onTap: () {}),
                  _drawerItem(Icons.bar_chart, 'Update Status', onTap: () {}),
                  _drawerItem(Icons.settings, 'Settings', onTap: () {}),
                  _drawerItem(Icons.privacy_tip, 'Privacy Policy',
                      onTap: () {}),
                  _drawerItem(Icons.feedback, 'Feedback', onTap: () {}),
                  _drawerItem(Icons.support, 'Support Us', onTap: () {}),
                  _drawerItem(Icons.info, 'About Us', onTap: () {}),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Color(0xFFDC2E2E)),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0xFFDC2E2E)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFDC2E2E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            // App Version and Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 8),
                  Text(
                    'App Version: 1.0.39(82)',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFDC2E2E),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text('  |  ', style: TextStyle(color: Colors.black54)),
                      Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: Color(0xFFDC2E2E),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      horizontalTitleGap: 0,
    );
  }
}
