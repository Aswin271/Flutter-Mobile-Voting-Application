import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Admin/admin_view.dart';
import 'package:online_voting_app/pages/Main_Pages/home_screen.dart';
import 'package:online_voting_app/pages/Main_Pages/register_page.dart';
import 'package:online_voting_app/user_auth/fire_base_auth/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Define form key
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // Loading state

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Use the provided loginUser function
        bool isLoggedIn = await loginUser(email, password);

        if (isLoggedIn) {
          // Get the user ID from Firebase Auth
          String userId = FirebaseAuth.instance.currentUser!.uid;

          // Check if the user is an admin or a regular user
          bool isAdmin = await checkIfAdmin(userId);

          if (isAdmin) {
            // Navigate to the AdminPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminView()),
            );
          } else {
            // Navigate to the UserHomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }

          // Show login success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Login failed. Please check your credentials.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  // Function to check if the user is an admin
  Future<bool> checkIfAdmin(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (snapshot.exists) {
        String role = snapshot['role'];
        return role == 'admin';
      }
      return false;
    } catch (e) {
      print('Error checking admin role: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 211, 204, 211), // Light blue background
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // Purple background for AppBar
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white, // White background for the logo
            child: Image.asset("assets/online-voting.png"), // Add your logo
          ),
        ),
        title: Text(
          'Quick Vote',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  const Color.fromARGB(255, 0, 0, 0)), // White text for title
        ),
      ),
      body: Center(
        child: Container(
          width: screenSize.width * 0.8, // Set width based on screen size
          height: screenSize.height * 0.6, // Set height based on screen size
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5), // Semi-transparent background
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey, // Use the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color.fromARGB(255, 0, 0, 0), // Purple color
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email,
                          color: Color.fromARGB(255, 0, 0, 0)), // Purple icon
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 0, 0, 0), // Purple icon
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock,
                          color: Color.fromARGB(255, 0, 0, 0)), // Purple icon
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 0, 0, 0), // Purple button
                    ),
                    onPressed:
                        _isLoading ? null : _login, // Disable button if loading
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white) // Show loading spinner
                        : Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white), // White text
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't already have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A3F8D), // Purple for sign-up text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
