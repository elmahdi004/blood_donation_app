import 'package:flutter/material.dart';
import 'package:blood_donation_app/constants.dart';

class DonorDetailsModal extends StatelessWidget {
  final String name;
  final String address;
  final String mobileNumber;
  final String status;
  final String imageUrl;

  const DonorDetailsModal({
    super.key,
    required this.name,
    required this.address,
    required this.mobileNumber,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Details Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Profile Image
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          const SizedBox(height: 24),
          // Details
          _buildDetailRow('Name', name),
          const Divider(height: 24),
          _buildDetailRow('Address', address),
          const Divider(height: 24),
          _buildDetailRow('Mobile Number', mobileNumber),
          const Divider(height: 24),
          _buildDetailRow('Current Status', status),
          const SizedBox(height: 24),
          // Request Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Handle donation request
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Request for Donates',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label : ',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
