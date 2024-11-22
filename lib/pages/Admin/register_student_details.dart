// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_voting_app/service/database.dart'; // Import your Firestore service

class StudentRegister extends StatefulWidget {
  const StudentRegister({super.key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  // TextEditingController for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  // Function to register student
  void registerStudent() async {
    String id = rollNumberController.text; // Use Roll Number as the unique ID
    Map<String, dynamic> studentInfoMap = {
      "name": nameController.text,
      "rollNumber": rollNumberController.text,
      "email": emailController.text,
      "department": departmentController.text,
    };

    // Store data in Firestore using DatabaseMethods class
    await DatabaseMethods().addStudentDetails(studentInfoMap, id).then((value) {
      Fluttertoast.showToast(
        msg: "Student Registered Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Clear the input fields after successful registration
      nameController.clear();
      rollNumberController.clear();
      emailController.clear();
      departmentController.clear();
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for Student Name
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    hintText: 'e.g., Aswin J',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // TextField for Roll Number
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: rollNumberController,
                  decoration: InputDecoration(
                    labelText: 'Roll Number',
                    hintText: 'e.g., MCA23-001',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // TextField for Email Address
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'e.g., example@example.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 20),

              // TextField for Department
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    hintText: 'e.g., MCA',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Register Button
              Center(
                child: ElevatedButton(
                  onPressed:
                      registerStudent, // Call the registerStudent function
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
