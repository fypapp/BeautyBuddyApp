import 'package:beautybuddyapp/categoryy_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DermatologistConsultationScreen extends StatefulWidget {
  @override
  _DermatologistConsultationScreenState createState() =>
      _DermatologistConsultationScreenState();
}

class _DermatologistConsultationScreenState
    extends State<DermatologistConsultationScreen> {
  Future<List<Map<String, dynamic>>> fetchDermatologists() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('dermatologists').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching dermatologists: $e");
      throw Exception('Failed to load dermatologist data.');
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      print('Error: Website URL is null or empty.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No website available for this dermatologist.'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not launch website. Ensure you have a browser installed and the URL is correct.',
              ),
            ),
          );
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
          'Dermatologists',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFFC6A7F2), // Purple color
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
        future: fetchDermatologists(),
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
            return Center(child: Text('No dermatologists found.'));
          }

          var dermatologists = snapshot.data!;

          return ListView.builder(
            itemCount: dermatologists.length,
            itemBuilder: (context, index) {
              var dermatologist = dermatologists[index];

              var name = dermatologist['name'] as String? ?? 'N/A';
              var address =
                  dermatologist['address'] as String? ?? 'No address provided';
              var imageUrl = dermatologist['imageUrl'] as String? ?? '';
              var websiteUrl = dermatologist['website'] as String?;

              ImageProvider imageProvider;
              bool useFallbackIcon = false;

              if (imageUrl.startsWith('assets/')) {
                imageProvider = AssetImage(imageUrl);
              } else if (imageUrl.isNotEmpty &&
                  (imageUrl.startsWith('http://') ||
                      imageUrl.startsWith('https://'))) {
                imageProvider = NetworkImage(imageUrl);
              } else {
                imageProvider = AssetImage('assets/placeholder_image.png');
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

                      child:
                          useFallbackIcon
                              ? Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey[400],
                              )
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
                        websiteUrl != null && websiteUrl.isNotEmpty
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
