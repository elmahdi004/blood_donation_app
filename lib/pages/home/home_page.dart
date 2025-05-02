import 'package:flutter/material.dart';
import 'package:blood_donation_app/constants.dart';
import 'package:blood_donation_app/widgets/donor_details_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for demonstration
  final List<Map<String, String>> _donors = [
    {
      'name': 'EL Mahdi bellaziz',
      'description': 'Active blood donor with 5+ donations',
      'bloodType': 'B+',
      'image': 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c',
      'address': 'Dr lamrahate Cr Saadla safi',
      'mobileNumber': '+212 619664459',
      'status': 'Ready for Donate'
    },
    {
      'name': 'Sarah Johnson',
      'description': 'Regular donor, available for emergency donations',
      'bloodType': 'A-',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      'address': 'Rue Hassan II, Quartier Administratif, Safi',
      'mobileNumber': '+212 622334455',
      'status': 'Ready for Donate'
    },
    {
      'name': 'Ahmed Hassan',
      'description': 'First-time donor, willing to help',
      'bloodType': 'O+',
      'image': 'https://images.unsplash.com/photo-1566492031773-4f4e44671857',
      'address': 'Avenue Mohammed V, Route Principale, Safi',
      'mobileNumber': '+212 633445566',
      'status': 'Available on Weekends'
    },
    {
      'name': 'Maria Garcia',
      'description': 'Regular blood donor since 2020',
      'bloodType': 'AB+',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      'address': 'Lot Riad Salam, Rue 12, Safi',
      'mobileNumber': '+212 644556677',
      'status': 'Ready for Donate'
    },
  ];

  void _showDonorDetails(Map<String, dynamic> donor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DonorDetailsModal(
        name: donor['name'],
        address: donor['address'],
        mobileNumber: donor['mobileNumber'],
        status: donor['status'],
        imageUrl: donor['image'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Menu and Notification
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFDC2E2E),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          // Add menu functionality
                        },
                      ),
                      const Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white),
                        onPressed: () {
                          // Add notification functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by location',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sort and Filter Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Add sort functionality
                      },
                      icon: const Icon(Icons.sort),
                      label: const Text('Sort'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Add filter functionality
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Donor List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _donors.length,
                itemBuilder: (context, index) {
                  final donor = _donors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Profile Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(donor['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Name and Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      donor['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      donor['description']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Blood Type
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  donor['bloodType']!,
                                  style: TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _showDonorDetails(donor),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black54,
                                    side:
                                        const BorderSide(color: Colors.black12),
                                  ),
                                  child: const Text('View Details'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _showDonorDetails(donor),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black54,
                                    side:
                                        const BorderSide(color: Colors.black12),
                                  ),
                                  child: const Text('Request for Donates'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Communication Icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.chat_bubble_outline,
                                    color: Colors.red[100]),
                                onPressed: () {
                                  // Add chat functionality
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.phone_outlined,
                                    color: Colors.red[100]),
                                onPressed: () {
                                  // Add call functionality
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'Home', true),
                  _buildNavItem(Icons.bloodtype, 'Blood Request', false),
                  _buildNavItem(Icons.person, 'Profile', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        // Add navigation functionality
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFDC2E2E) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFDC2E2E) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
