import 'package:beautybuddyapp/auth.dart';
import 'package:beautybuddyapp/facerecognition_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCh5gZdEVwhb2qV0nQqC98zCDa9rm16lHk",
        authDomain: "beautybuddy-app.firebaseapp.com",
        projectId: "beautybuddy-app",
        storageBucket: "beautybuddy-app.firebasestorage.app",
        messagingSenderId: "983675061777",
        appId: "1:983675061777:web:981f9532dd70a40039d3b0",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyBuddy App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFC6A7F2)),
        useMaterial3: true,
      ),

      home: SplashScreen(),
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return FaceRecognitionScreen();
        }

        return LoginScreen();
      },
    );
  }
}
