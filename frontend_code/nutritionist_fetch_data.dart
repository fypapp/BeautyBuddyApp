import 'package:beautybuddyapp/categoryy_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionistConsultationScreen extends StatefulWidget {
  @override
  _NutritionistConsultationScreenState createState() =>
      _NutritionistConsultationScreenState();
}

class _NutritionistConsultationScreenState
    extends State<NutritionistConsultationScreen> {
  Future<List<Map<String, dynamic>>> fetchNutritionists() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('drnutrition').get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching nutritionists: $e");

      throw Exception('Failed to load nutritionist data.');
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      print('Error: Website URL is null or empty.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No website available for this nutritionist.'),
          ),
        );
      }
      return;
    }

    String launchUrlString = url;

    try {
      if (!launchUrlString.startsWith('http://') &&
          !launchUrlString.startsWith('https://')) {
        launchUrlString = 'https://$launchUrlString';
      }

      final Uri uri = Uri.parse(launchUrlString);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Error: Could not launch $launchUrlString');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch website.')));
        }
      }
    } catch (e) {
      print('Launch error for URL "$url": $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid URL format or cannot launch.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutritionists',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFFC6A7F2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNutritionists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("FutureBuilder Error: ${snapshot.error}");
            return Center(
              child: Text(
                'Error loading data. Please try again later.',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('No nutritionists found.'));
          }

          var nutritionists = snapshot.data!;

          return ListView.builder(
            itemCount: nutritionists.length,
            itemBuilder: (context, index) {
              var nutritionist = nutritionists[index];

              var name = nutritionist['nutrition_name'] as String? ?? 'Unknown';
              var address =
                  nutritionist['nutrition_address'] as String? ??
                  'No address provided';
              var imageUrl = nutritionist['nutrition_image'] as String? ?? '';
              var websiteUrl =
                  nutritionist['nutrition_websitelink'] as String? ?? '';

              ImageProvider imageProvider;
              bool useFallbackIcon = false;

              if (imageUrl.startsWith('assets/')) {
                imageProvider = AssetImage(imageUrl);
              } else if (imageUrl.isNotEmpty &&
                  (imageUrl.startsWith('http://') ||
                      imageUrl.startsWith('https://'))) {
                imageProvider = NetworkImage(imageUrl);
              } else {
                imageProvider = AssetImage('assets/defaultpic.jpg');
                if (imageUrl.isNotEmpty) {
                  print(
                    "Warning: Invalid image URL format for $name: $imageUrl. Using fallback.",
                  );
                }
              }

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: !useFallbackIcon ? imageProvider : null,
                      onBackgroundImageError:
                          !useFallbackIcon &&
                                  imageUrl.isNotEmpty &&
                                  !imageUrl.startsWith('assets/')
                              ? (exception, stackTrace) {
                                print(
                                  "Error loading network image: $imageUrl, Error: $exception",
                                );
                              }
                              : null,
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(address),
                  trailing: IconButton(
                    icon: Icon(Icons.open_in_browser, color: Color(0xFFC6A7F2)),
                    tooltip: 'Visit Website',
                    onPressed:
                        websiteUrl.isNotEmpty
                            ? () => _launchURL(websiteUrl)
                            : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
