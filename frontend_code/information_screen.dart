import 'package:beautybuddyapp/profile_screen.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Information',
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          _buildSectionTitle('About the App'),
          _buildContentText(
            'BeautyBuddy is an AI-powered cosmetic recommendation app designed to help users find the best skincare products, dietary tips, and dermatologist advice based on their unique skin profile.',
          ),

          const SizedBox(height: 20),

          _buildSectionTitle('How Does It Work?'),
          _buildBulletPoints([
            'Capture a face image using the app.',
            'AI analyzes your skin type, tone, and acne severity.',
            'Choose from: AI Cosmetic Recommendations, Dietary Recommendation, & Dermatologist Consultation.',
          ]),

          const SizedBox(height: 20),

          _buildSectionTitle('What We Analyze'),
          _buildBulletPoints(['Skin Type ', 'Skin Tone', 'Acne Severity']),

          const SizedBox(height: 20),

          _buildSectionTitle('What You Can Do'),
          _buildBulletPoints([
            'Get personalized AI Cosmetic Recommendations.',
            'Receive a Dietary Plan to improve skin health.',
            'Find contact details of  Dermatologists.',
          ]),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC6A7F2),
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  Expanded(
                    child: Text(point, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
