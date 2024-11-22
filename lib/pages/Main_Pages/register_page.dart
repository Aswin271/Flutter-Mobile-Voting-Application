import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_voting_app/pages/Main_Pages/login_page.dart';
import 'package:online_voting_app/user_auth/fire_base_auth/firebase_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedGender = "Male"; // Default gender
  String? selectedDepartment;
  bool obscurePasswordText = true; // Obscure text for password
  bool obscureConfirmPasswordText = true; // Obscure text for confirm password

  List<String> genders = ["Male", "Female"];
  List<String> departments = [
    "Select Department", // Default selection
    "CSE", "ECE", "Mechanical", "Civil", "IT", "Bio-Tech", "Electrical"
  ];

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    rollNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String rollNo = rollNoController.text.trim();

      try {
        // Cross-check if the roll number exists in the "Students" collection
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection("Students")
            .doc(rollNo)
            .get();

        if (studentDoc.exists) {
          // Roll number exists, proceed with registration
          String fullName = fullNameController.text.trim();
          String dob = dobController.text.trim();
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          String? department = selectedDepartment;

          // Prepare user info to store in Firestore
          Map<String, dynamic> userInfoMap = {
            'name': fullName,
            'dob': dob,
            'gender': selectedGender,
            'department': department,
            'rollNo': rollNo,
            'email': email,
          };

          bool isRegistered = await signUpUser(userInfoMap, email, password);

          if (isRegistered) {
            // Clear fields and show success message
            fullNameController.clear();
            dobController.clear();
            rollNoController.clear();
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            setState(() {
              selectedGender = "Male";
              selectedDepartment = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful')),
            );

            // Navigate to the login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed.')),
            );
          }
        } else {
          // Roll number does not exist, show an error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Invalid roll number. Please contact admin.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: screenSize.width * 0.8,
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up!",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),

                    // Full Name
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Full Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date of Birth
                    TextFormField(
                      controller: dobController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Date of Birth (dd/mm/yyyy)",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                          return 'Please enter a valid date in dd/mm/yyyy format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Gender",
                      ),
                      items: genders.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!; // Set selected value
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Department Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Department",
                      ),
                      items: departments.map((String department) {
                        return DropdownMenuItem<String>(
                          value: department,
                          child: Text(department),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value; // Set selected value
                        });
                      },
                      validator: (value) {
                        if (value == null || value == "Select Department") {
                          return 'Please select a department';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Roll Number
                    TextFormField(
                      controller: rollNoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Roll No",
                        prefixIcon: const Icon(Icons.numbers, size: 18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your roll number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email, size: 18),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePasswordText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePasswordText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePasswordText =
                                  !obscurePasswordText; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPasswordText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPasswordText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPasswordText =
                                  !obscureConfirmPasswordText; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
