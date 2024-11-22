// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Admin/admin_view.dart';
import 'package:online_voting_app/pages/Main_Pages/splash_screen.dart';
import 'package:online_voting_app/pages/Main_Pages/login_page.dart'; // Import your login page
import 'package:online_voting_app/pages/Main_Pages/home_screen.dart'; // Import your home screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for both web and mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCmW1JnTsGxCK7ZP7d6u0sNj3jP4ZEmzkE",
        authDomain: "online-voting-app-80aab.firebaseapp.com",
        projectId: "online-voting-app-80aab",
        storageBucket: "online-voting-app-80aab.appspot.com",
        messagingSenderId: "98532105599",
        appId: "1:98532105599:web:37f6e4895c475ab9bdce4a",
      ),
    );
  } else {
    await Firebase.initializeApp();

    // Ensure persistence for authentication across sessions
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  // Run the main application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Voting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set the initial screen to SplashScreen
      home: const SplashScreen(),
      // home: const AdminView(),
      // home: const HomeScreen(),

      // Define the routes for navigation
      routes: {
        '/login': (context) => LoginPage(), // Add your login page route
        '/home': (context) => HomeScreen(), // Add your home page route
        // Add more routes as needed
      },
    );
  }
}
