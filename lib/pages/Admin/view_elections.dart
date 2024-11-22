import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_candidate.dart'; // Import your AddCandidate file

class ViewElections extends StatefulWidget {
  const ViewElections({super.key});

  @override
  State<ViewElections> createState() => _ViewElectionsState();
}

class _ViewElectionsState extends State<ViewElections> {
  List<Map<String, dynamic>> elections = []; // To store elections
  String? selectedElectionId; // To track the selected election

  @override
  void initState() {
    super.initState();
    fetchElections(); // Fetch elections when the widget is initialized
  }

  // Fetch elections from Firestore
  Future<void> fetchElections() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Elections').get();
      setState(() {
        elections = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching elections: $e');
    }
  }

  // Navigate to AddCandidate page
  void _addCandidate() {
    if (selectedElectionId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCandidate(electionId: selectedElectionId!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an election")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Elections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown to select an election
            DropdownButton<String>(
              value: selectedElectionId,
              hint: Text('Select Election'),
              items: elections.map((election) {
                return DropdownMenuItem<String>(
                  value: election['id'],
                  child: Text(election['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedElectionId = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Button to add candidate
            ElevatedButton(
              onPressed: _addCandidate,
              child: Text("Add Candidate"),
            ),
            Expanded(
              // List of elections
              child: ListView.builder(
                itemCount: elections.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(elections[index]['name']),
                    subtitle: Text(
                        'Start: ${elections[index]['startTime'].toDate()} End: ${elections[index]['endTime'].toDate()}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
