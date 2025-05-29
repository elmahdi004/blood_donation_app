import 'package:blood_donation_app/pages/splash/First.dart';
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/44.jpg',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'El Mahdi Bellaziz',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'elmahdi.bellaziz@gmail.com',
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
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BodySplash(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black54),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                  minimumSize: const Size.fromHeight(48),
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
      title: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      horizontalTitleGap: 0,
    );
  }
}
