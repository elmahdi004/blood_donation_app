import 'package:flutter/material.dart';
import 'package:blood_donation_app/pages/auth/signup/address.dart';
import 'package:blood_donation_app/constants.dart';

class BloodGroupPage extends StatefulWidget {
  final Map<String, String> userData;

  const BloodGroupPage({
    super.key,
    required this.userData,
  });

  @override
  State<BloodGroupPage> createState() => _BloodGroupPageState();
}

class _BloodGroupPageState extends State<BloodGroupPage> {
  String? selectedBloodGroup;
  String? selectedRhFactor;

  void _navigateToAddress() {
    if (selectedBloodGroup != null && selectedRhFactor != null) {
      final updatedUserData = Map<String, String>.from(widget.userData);
      updatedUserData['group_sanguin'] = '$selectedBloodGroup$selectedRhFactor';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressPage(userData: updatedUserData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Veuillez sélectionner votre groupe sanguin et facteur Rh'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Back Button and Title
            Container(
              padding: const EdgeInsets.all(16),
              color: mainColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Choisissez votre groupe sanguin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Text(
                        '2/3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 60,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index < 2
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Blood drop icon
            const Icon(
              Icons.water_drop,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 40),
            // White container with blood group options
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Blood group grid
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _bloodGroupButton('A'),
                          _bloodGroupButton('B'),
                          _bloodGroupButton('O'),
                          _bloodGroupButton('AB'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // RH factor buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _rhFactorButton('+'),
                        const SizedBox(width: 16),
                        _rhFactorButton('-'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _navigateToAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Suivant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign in text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle sign in tap
                          },
                          child: Text(
                            'Sign In!',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloodGroupButton(String bloodGroup) {
    final isSelected = selectedBloodGroup == bloodGroup;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBloodGroup = bloodGroup;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? mainColor : const Color(0xFFFCE7E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            bloodGroup,
            style: TextStyle(
              color: isSelected ? Colors.white : mainColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rhFactorButton(String factor) {
    final isSelected = selectedRhFactor == factor;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRhFactor = factor;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? mainColor : const Color(0xFFFCE7E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            factor,
            style: TextStyle(
              color: isSelected ? Colors.white : mainColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
