import 'package:flutter/material.dart';

class BloodGroupPage extends StatefulWidget {
  const BloodGroupPage({super.key});

  @override
  State<BloodGroupPage> createState() => _BloodGroupPageState();
}

class _BloodGroupPageState extends State<BloodGroupPage> {
  String? selectedBloodGroup;
  String? selectedRhFactor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDC3545),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pick Your Blood Group',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '4/4',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Progress indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          // Blood drop icon
          Icon(
            Icons.water_drop,
            size: 100,
            color: Colors.white,
          ),
          const SizedBox(height: 60),
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
                  const SizedBox(
                    height: 15,
                  ),
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
                  // Finish button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle finish button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC3545),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                        child: const Text(
                          'Sign In!',
                          style: TextStyle(
                            color: Color(0xFFDC3545),
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
          color: isSelected ? const Color(0xFFDC3545) : const Color(0xFFFCE7E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            bloodGroup,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFDC3545),
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
          color: isSelected ? const Color(0xFFDC3545) : const Color(0xFFFCE7E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            factor,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFDC3545),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
