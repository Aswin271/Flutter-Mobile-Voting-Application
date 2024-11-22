import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class AddElection extends StatefulWidget {
  const AddElection({super.key});

  @override
  State<AddElection> createState() => _AddElectionState();
}

class _AddElectionState extends State<AddElection> {
  final TextEditingController _electionNameController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

// Function to save the election to Firestore
  Future<void> _addElection() async {
    if (_electionNameController.text.isEmpty ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // Add the election to Firestore
      final DocumentReference electionRef =
          await FirebaseFirestore.instance.collection('Elections').add({
        'name': _electionNameController.text,
        'startTime': _startTime,
        'endTime': _endTime,
        'isPublished': false, // Add isPublished field and set it to false
      });

      // Get the newly created election ID
      final String electionId = electionRef.id;

      // Initialize the hasVoted field for all users
      await initializeVotingStatus(electionId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Election added successfully")),
      );
      _electionNameController.clear();
      setState(() {
        _startTime = null;
        _endTime = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding election: $e")),
      );
    }
  }

// Function to initialize hasVoted field for all users
  Future<void> initializeVotingStatus(String electionId) async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    for (var userDoc in usersSnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDoc.id)
          .update({
        'hasVoted.$electionId': false,
      });
    }
  }

  // Function to select date and time
  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );

        setState(() {
          if (isStartTime) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Select Time";
    return DateFormat('dd/MM/yyyy HH:mm')
        .format(dateTime); // Format the date and time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Election"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _electionNameController,
              decoration: const InputDecoration(labelText: "Election Name"),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Start Time: ${_formatDateTime(_startTime)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context, true),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "End Time: ${_formatDateTime(_endTime)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context, false),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addElection,
              child: const Text("Add Election"),
            ),
          ],
        ),
      ),
    );
  }
}
