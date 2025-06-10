import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beautybuddyapp/facerecognition_screen.dart';
import 'package:beautybuddyapp/dermatologist_consultation_screen.dart';
import 'package:beautybuddyapp/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beautybuddyapp/nutritionist_fetch_data.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String productLink = '';

  Future<void> fetchProductLink(String productName) async {
    setState(() {
      productLink = '';
    });
    try {
      print('DEBUG: fetchProductLink called with name: "$productName"');

      QuerySnapshot productSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('name', isEqualTo: productName)
              .limit(1)
              .get();

      print(
        'DEBUG: Product Snapshot Data for "$productName": ${productSnapshot.docs.isNotEmpty ? productSnapshot.docs.first.data() : 'No product found'}',
      );

      if (productSnapshot.docs.isNotEmpty) {
        final fetchedData =
            productSnapshot.docs.first.data() as Map<String, dynamic>?;
        final fetchedLink = fetchedData?['link'] as String?;

        if (fetchedLink != null && fetchedLink.isNotEmpty) {
          setState(() {
            productLink = fetchedLink;
          });

          print('DEBUG: State updated. productLink = $productLink');
        } else {
          print(
            'DEBUG: Product found for "$productName", but "link" field is missing, empty, or not a String.',
          );
        }
      } else {
        print(
          'DEBUG: Product with name "$productName" not found in Firestore.',
        );
      }
    } catch (e) {
      print('Error fetching product link for "$productName": $e');

      setState(() {
        productLink = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FaceRecognitionScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose the ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Service You Need',
                style: TextStyle(
                  color: Color(0xFFC6A7F2),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Categories',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 25),

              CategoryCard(
                title: 'AI Cosmetic Recommendation',
                iconPath: 'assets/images/ai_star.png',
                onTap: () async {
                  print('DEBUG: AI Card tapped.');
                  print(
                    'DEBUG: Current globalProductName = $globalProductName',
                  );

                  if (isProductFetched &&
                      globalProductName != null &&
                      globalProductName!.isNotEmpty) {
                    await fetchProductLink(globalProductName!);
                    print(
                      'DEBUG: fetchProductLink finished. Current state productLink = $productLink',
                    );
                    if (productLink.isNotEmpty) {
                      print(
                        'DEBUG: Navigating to ProductDetailScreen with name: "${globalProductName!}" and link: "$productLink"',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetailScreen(
                                name: globalProductName!,
                                imageUrl: globalProductImageUrl ?? '',
                                description: globalProductDescription ?? '',
                                productLink: productLink,
                              ),
                        ),
                      );
                    } else {
                      print(
                        'DEBUG: Navigation skipped because productLink is empty after fetch.',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Link for product "${globalProductName!}" is unavailable!',
                          ),
                        ),
                      );
                    }
                  } else {
                    print(
                      'DEBUG: Condition not met for AI Rec. isProductFetched=$isProductFetched, globalProductName=$globalProductName',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isProductFetched
                              ? 'Recommended product data is incomplete!'
                              : 'No product found yet. Please analyze first!',
                        ),
                      ),
                    );
                  }
                },
              ),

              SizedBox(height: 26),

              CategoryCard(
                title: 'Dietary Recommendation',
                iconPath: 'assets/images/nutrition.png',
                onTap: () {
                  if (globalDietPlan != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DietPlanDetailScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'No diet plan found yet. Please analyze first!',
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 26),
              CategoryCard(
                title: 'Dermatologist Consultation',
                iconPath: 'assets/images/doctor.png',
                onTap: () {
                  //Navigate to the Dermatologist Consultation screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DermatologistConsultationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFC6A7F2), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        width: double.infinity,
        height: 120,
        child: Row(
          children: [
            Image.asset(iconPath, width: 55, height: 60),
            SizedBox(width: 24),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DietPlanDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        title: Text(
          "Dietary Recommendation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.0),
            Container(
              padding: EdgeInsets.all(16.0),
              height: 550,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15.0,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        'Diet Plan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 98),
                      Image.asset('assets/images/diet_icon.png', height: 90),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (globalDietPlan != null && globalDietPlan!.isNotEmpty)
                    ..._buildDietPlanList(globalDietPlan!),
                  SizedBox(height: 55),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => NutritionistConsultationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Get Nutritionist Advice',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC6A7F2),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDietPlanList(String dietPlan) {
    List<String> dietPlanLines = dietPlan.split('\n');

    return dietPlanLines.map((line) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(Icons.check_rounded, size: 25, color: Colors.blue),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                line.trim(),
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// Product Detail Screen

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String productLink;

  const ProductDetailScreen({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.productLink,
  }) : super(key: key);

  Future<void> addToFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final CollectionReference favoritesCollection = FirebaseFirestore.instance
          .collection('favoritelist');

      try {
        await favoritesCollection.add({
          'name': name,
          'imageUrl': imageUrl,
          'email': user.email,
        });
        print("Product added to favorites!");
      } catch (e) {
        print("Error adding product to favorites: $e");
      }
    } else {
      print('User not logged in');
    }
  }

  //Add to Cart Functionality
  Future<void> addToCart(BuildContext context) async {
    print(
      'DEBUG: ProductDetailScreen addToCart called. Launching link: $productLink',
    );

    if (productLink.isNotEmpty &&
        (productLink.startsWith('http://') ||
            productLink.startsWith('https://'))) {
      final Uri url = Uri.parse(productLink);
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print('DEBUG: Could not launch $url');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the product link.')),
          );
        }
      } catch (e) {
        print("Error parsing or launching product link '$productLink': $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening product link.')));
      }
    } else {
      print(
        'DEBUG: Add to cart skipped because productLink is empty or invalid: "$productLink"',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product link is not available or invalid.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'DEBUG: ProductDetailScreen build. Name: "$name", Received productLink: "$productLink"',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        title: Text(
          "Recommendation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.startsWith('http')
                ? Image.network(imageUrl, fit: BoxFit.cover, height: 300)
                : Image.asset(imageUrl, fit: BoxFit.cover, height: 300),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 17.0),
                  Text(
                    description,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: addToFavorites,
                        icon: Icon(Icons.favorite, color: Colors.white),
                        label: Text(
                          "Favorite",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD1B3FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: () => addToCart(context),
                        icon: Icon(Icons.shopping_cart, color: Colors.white),
                        label: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD1B3FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
