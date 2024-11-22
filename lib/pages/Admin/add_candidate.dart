// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class AddCandidate extends StatefulWidget {
  const AddCandidate({super.key, required this.electionId});

  final String electionId;

  @override
  State<AddCandidate> createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  String? year; // Dropdown value for year

  Future<void> addCandidate() async {
    if (nameController.text.isNotEmpty &&
        partyController.text.isNotEmpty &&
        positionController.text.isNotEmpty &&
        departmentController.text.isNotEmpty &&
        year != null) {
      // Prepare candidate data with the votes field
      Map<String, dynamic> candidateInfoMap = {
        'name': nameController.text,
        'party': partyController.text,
        'position': positionController.text,
        'department': departmentController.text,
        'year': year,
        'electionId': widget.electionId, // Include election ID
        'votes': 0, // Set initial votes to 0
      };

      // Generate a unique ID for the candidate
      String candidateId = DateTime.now().millisecondsSinceEpoch.toString();

      // Add candidate details to Firestore
      await addCandidateDetails(candidateInfoMap, candidateId);

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate added successfully!')),
      );

      // Clear the fields after submission
      nameController.clear();
      partyController.clear();
      positionController.clear();
      departmentController.clear();
      setState(() {
        year = null;
      });
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<void> addCandidateDetails(
      Map<String, dynamic> candidateInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Candidates")
        .doc(id)
        .set(candidateInfoMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Candidate Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for Candidate Name
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Candidate Name',
                    hintText: 'e.g., Aswin J',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // TextField for Party Name
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: partyController,
                  decoration: InputDecoration(
                    labelText: 'Party Name',
                    hintText: 'e.g., Democratic Party',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // TextField for Position
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'Position',
                    hintText: 'e.g., President, VP',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Dropdown for Year
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: DropdownButtonFormField<String>(
                  value: year,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: ['1st Year', '2nd Year', '3rd Year', '4th Year']
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      year = value;
                    });
                  },
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

              // Add Candidate Button
              Center(
                child: ElevatedButton(
                  onPressed: addCandidate, // Call the add candidate function
                  child: Text(
                    "ADD CANDIDATE",
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
