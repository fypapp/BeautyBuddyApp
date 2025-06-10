import 'dart:convert';
import 'dart:io';

import 'package:beautybuddyapp/categoryy_screen.dart';
import 'package:beautybuddyapp/globals.dart';
import 'package:beautybuddyapp/profile_screen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initCamera();
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg,
          enableAudio: false,
        );
        await _cameraController.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      final image = await _cameraController.takePicture();
      setState(() {
        _imageFile = image;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => DisplayCapturedImageScreen(imageFile: _imageFile!),
        ),
      );
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [HomeScreen(), CategoryScreen(), ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFC6A7F2),
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view, size: 30),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(radius: 80, backgroundColor: Color(0xFFF4E8FD)),
                CircleAvatar(radius: 60, backgroundColor: Color(0xFFE3D7F5)),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFC6A7F2),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraCaptureScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Face Recognition',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Discover Your Skin's Unique Needs",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 120),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraCaptureScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC6A7F2),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 100,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isCameraReady = false;
  bool _isFrontCamera = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  Future<void> _toggleCamera() async {
    final currentCamera = _isFrontCamera ? cameras[0] : cameras[1];
    _controller = CameraController(
      currentCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller.initialize();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  Future<void> _captureImage() async {
    try {
      final image = await _controller.takePicture();
      setState(() {
        _imageFile = image;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => DisplayCapturedImageScreen(imageFile: _imageFile!),
        ),
      );
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        title: const Text(
          "Capture Image",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera, color: Colors.white),
            iconSize: 30,
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Center(
        child:
            _isCameraReady
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 470, child: CameraPreview(_controller)),
                    const SizedBox(height: 20),
                    Text(
                      "Please click a picture without makeup.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _captureImage,
                      child: const Text(
                        "Capture Image",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC6A7F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DisplayCapturedImageScreen extends StatelessWidget {
  final XFile imageFile;

  const DisplayCapturedImageScreen({super.key, required this.imageFile});

  Future<void> _saveToGalleryAndAnalyze(BuildContext context) async {
    await ImageGallerySaverPlus.saveFile(imageFile.path);
    await _sendImageToFlask(context);
  }

  Future<void> _sendImageToFlask(BuildContext context) async {
    try {
      final uri = Uri.parse('http://192.168.100.232:5000/analyze');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final analysisResult = jsonDecode(responseData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    AnalysisResultScreen(analysisResult: analysisResult),
          ),
        );
      } else {
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        title: Text(
          'Display Image',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CameraCaptureScreen()),
              ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 450,
              width: 320,
              child: Image.file(File(imageFile.path), fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveToGalleryAndAnalyze(context),
              child: Text(
                'Save and Analyze',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC6A7F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalysisResultScreen extends StatelessWidget {
  final Map<String, dynamic> analysisResult;

  const AnalysisResultScreen({super.key, required this.analysisResult});

  Future<void> fetchDietPlan(
    String skinType,
    String skinTone,
    String acneSeverity,
    BuildContext context,
  ) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var nutritionRef = firestore.collection('nutrition');

      var querySnapshot =
          await nutritionRef
              .where('nutrition_skin_type', isEqualTo: skinType)
              .where('nutrition_skin_tone', isEqualTo: skinTone)
              .where('acne_severity', isEqualTo: acneSeverity)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var dietPlan = querySnapshot.docs.first;
        globalDietPlan = dietPlan['diet_plan'];
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No matching diet plan found')));
      }
    } catch (e) {
      print("Error fetching diet plan: $e");
    }
  }

  Future<void> fetchMatchingProduct(
    BuildContext context,
    String skinType,
    String skinTone,
    String acneSeverity,
  ) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var productsRef = firestore.collection('products');

      var querySnapshot =
          await productsRef
              .where('skin_type', isEqualTo: skinType)
              .where('skin_tone', isEqualTo: skinTone)
              .where('acne_compatible', isEqualTo: acneSeverity)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var product = querySnapshot.docs.first;

        globalProductName = product['name'];
        globalProductImageUrl = product['image_url'];
        globalProductDescription = product['description'];
        isProductFetched = true;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No matching products found')));
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String skinType = analysisResult['Skin Type'] ?? 'Unknown';
    String skinTone = analysisResult['Skin Tone'] ?? 'Unknown';
    String acneSeverity = analysisResult['Acne Severity'] ?? 'Unknown';

    Future.wait([
      fetchDietPlan(skinType, skinTone, acneSeverity, context),
      fetchMatchingProduct(context, skinType, skinTone, acneSeverity),
    ]).then((_) {
      print('Both queries completed');
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC6A7F2),
        title: Text(
          'Analysis Result',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FaceRecognitionScreen(),
                ),
              ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Skin Analysis',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30),
              _buildResultTile(
                'Acne Severity',
                analysisResult['Acne Severity'] ?? 'Unknown',
              ),
              _buildResultTile(
                'Skin Tone',
                analysisResult['Skin Tone'] ?? 'Unknown',
              ),
              _buildResultTile(
                'Skin Type',
                analysisResult['Skin Type'] ?? 'Unknown',
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryScreen()),
                  );
                },
                child: Text(
                  'Get Recommendation',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC6A7F2),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultTile(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
