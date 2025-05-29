import 'package:flutter/material.dart';
import 'package:blood_donation_app/constants.dart';
import 'package:blood_donation_app/widgets/donor_details_modal.dart';
import 'package:blood_donation_app/pages/home/custom_drawer.dart';

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

  void _showBloodRequestModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Request of Blood',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDEDED),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Icon(Icons.volunteer_activism,
                              color: mainColor, size: 48),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _modalTextField('Patient Name'),
                      const SizedBox(height: 12),
                      _modalTextField('Medical Name'),
                      const SizedBox(height: 12),
                      _modalTextField('Phone Number',
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 12),
                      _modalTextField('Units/Blood Bag',
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                      _modalDropdown('Select Blood Group',
                          ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']),
                      const SizedBox(height: 12),
                      _modalTextField('Blood Donation Date',
                          readOnly: true, onTap: () {}),
                      const SizedBox(height: 12),
                      _modalTextField('Blood Donation Time',
                          readOnly: true, onTap: () {}),
                      const SizedBox(height: 12),
                      _modalDropdown('Select District',
                          ['District 1', 'District 2', 'District 3']),
                      const SizedBox(height: 12),
                      _modalTextField('Area'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modalTextField(String hint,
      {TextInputType keyboardType = TextInputType.text,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return TextField(
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _modalDropdown(String hint, List<String> items) {
    String? selectedValue;
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => selectedValue = val),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  void _showNotificationsModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.notifications_active,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['message']!,
                                  style: const TextStyle(fontSize: 15),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification['time']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> _notifications = [
    {
      'message': 'Blood is urgently needed for patients undergoing surgery.',
      'time': '1h ago',
    },
    {
      'message': 'Your last donation was 3 months ago. Ready to donate again?',
      'time': '2h ago',
    },
    {
      'message': 'Thank you for being a regular donor!',
      'time': '5h ago',
    },
    {
      'message': 'New blood donation camp in your area tomorrow.',
      'time': '1d ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Menu and Notification
            Container(
              padding: const EdgeInsets.all(16),
              color: mainColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
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
                        onPressed: _showNotificationsModal,
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
        if (label == 'Blood Request') {
          _showBloodRequestModal();
        } else {
          // Add navigation functionality
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? mainColor : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? mainColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
