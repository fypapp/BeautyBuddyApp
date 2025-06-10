import 'package:beautybuddyapp/profile_screen.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy & Security Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFFC6A7F2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildSectionTitle('1. Introduction'),
            _buildParagraph(
              'BeautyBuddy is committed to protecting your privacy. This policy explains how we collect, use, and secure your personal data within the app.',
            ),

            _buildSectionTitle('2. Data Collection'),
            _buildBulletPoints([
              'Face images (used for skin analysis)',
              'User profile details (name, email)',
              'App usage data (to improve user experience)',
            ]),

            _buildSectionTitle('3. How We Use Your Data'),
            _buildBulletPoints([
              'To analyze your skin type, tone, and acne severity.',
              'To provide personalized cosmetic, dietary, and dermatologist recommendations.',
              'To improve app performance and features.',
            ]),

            _buildSectionTitle('4. Data Storage & Security'),
            _buildParagraph(
              'We use secure cloud storage (e.g. Firebase) to store your data. Your data is encrypted and only used within the app for recommendation purposes. We do not share or sell your personal data to third parties.',
            ),

            _buildSectionTitle('5. Third-Party Services'),
            _buildParagraph(
              'BeautyBuddy uses third-party services such as Firebase Authentication and Firestore Database for secure login and data storage. These services follow their own privacy and security standards.',
            ),

            _buildSectionTitle('6. Contact Us'),
            _buildParagraph(
              'If you have any questions or concerns about your privacy, please contact us at:\n\nsupport@beautybuddyapp.com',
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                'Last Updated: April 30, 2025',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFC6A7F2),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text(point, style: TextStyle(fontSize: 16))),
                ],
              ),
            );
          }).toList(),
    );
  }
}
