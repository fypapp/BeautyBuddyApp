import 'package:beautybuddyapp/auth.dart';
import 'package:beautybuddyapp/facerecognition_screen.dart';
import 'package:beautybuddyapp/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmpasswordController.text;
    final name = nameController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      final userCredential = await Auth().createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fullname': name,
          'email': email,
          'password': password,
          'createdAt': Timestamp.now(),
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FaceRecognitionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Sign-up failed: $e")));
    }
  }

  Widget _buildInputField(
    BuildContext context,
    TextEditingController controller,
    String hintText,
    IconData icon, {
    bool obscureText = false,
    VoidCallback? onVisibilityToggle,
    bool showEyeIcon = false,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFC6A7F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                suffixIcon:
                    showEyeIcon
                        ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: onVisibilityToggle,
                        )
                        : null,
                hintText: hintText,
                fillColor: Color(0xFFD8D8D8),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.12),
                    Image.asset(
                      'assets/images/logoapp.png',
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                    ),
                    // Full Name field
                    _buildInputField(
                      context,
                      nameController,
                      "Full Name",
                      Icons.person_outline,
                      showEyeIcon: false,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    _buildInputField(
                      context,
                      emailController,
                      "Email Address",
                      Icons.email_outlined,
                      showEyeIcon: false,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    _buildInputField(
                      context,
                      passwordController,
                      "Password",
                      Icons.lock_clock_outlined,
                      obscureText: _obscureText1,
                      onVisibilityToggle: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                      showEyeIcon: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    _buildInputField(
                      context,
                      confirmpasswordController,
                      "Confirm Password",
                      Icons.lock_clock_outlined,
                      obscureText: _obscureText2,
                      onVisibilityToggle: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                      showEyeIcon: true,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC6A7F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
