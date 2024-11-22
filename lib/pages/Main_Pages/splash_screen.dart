import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Admin/admin_view.dart';
import 'package:online_voting_app/pages/Main_Pages/home_screen.dart';
import 'package:online_voting_app/pages/Main_Pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  // Check if the user is already logged in
  void checkLoginState() async {
    await Future.delayed(Duration(seconds: 4)); // Delay to show splash screen

    // Get the currently signed-in user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in
      try {
        String role = await getUserRole(user.uid);

        // Navigate based on the role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminView()),
          );
        } else if (role == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Handle unexpected roles or missing roles, defaulting to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        // Handle errors in case of role checking failures
        print('Error checking user role: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user role. Please try again.')),
        );
        // Optionally navigate to login page or retry mechanism here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      // No user is signed in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Function to get user role from Firestore
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (snapshot.exists) {
        String role = snapshot['role'] ?? 'User'; // Default role is 'User'
        return role; // Return the user's role
      }
      return 'User'; // Default to 'User' if no role exists
    } catch (e) {
      print('Error checking role: $e');
      return 'User'; // Default to 'User' in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 245, 245, 245),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    "assets/online-voting.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Quick Vote",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Voting Made Effortless",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
