import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting_app/pages/Admin/candidate_vote_view.dart';
// Import the CandidateVoteView

class AdminResultView extends StatefulWidget {
  const AdminResultView({super.key});

  @override
  State<AdminResultView> createState() => _AdminResultViewState();
}

class _AdminResultViewState extends State<AdminResultView> {
  // Fetch all elections from Firestore
  Stream<QuerySnapshot> _fetchAllElections() {
    return FirebaseFirestore.instance.collection('Elections').snapshots();
  }

  // Function to publish the result by setting isPublished to true
  Future<void> _publishResult(String electionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Elections')
          .doc(electionId)
          .update({'isPublished': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Results published successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error publishing result: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Results"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchAllElections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading elections: ${snapshot.error}"));
          }
          final elections = snapshot.data?.docs;

          if (elections == null || elections.isEmpty) {
            return const Center(child: Text("No elections found."));
          }

          return ListView.builder(
            itemCount: elections.length,
            itemBuilder: (context, index) {
              final election = elections[index];
              final startTime = (election['startTime'] as Timestamp).toDate();
              final endTime = (election['endTime'] as Timestamp).toDate();
              final bool isPublished = election['isPublished'] ?? false;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        election['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Start: ${DateFormat('dd/MM/yyyy HH:mm').format(startTime)}\n"
                        "End: ${DateFormat('dd/MM/yyyy HH:mm').format(endTime)}",
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to CandidateVoteView with the election ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateVoteView(
                                electionId: election.id,
                              ),
                            ),
                          );
                        },
                        child: const Text("View Candidates"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: isPublished
                            ? null
                            : () {
                                // Publish result and set isPublished to true
                                _publishResult(election.id);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPublished
                              ? Colors.grey
                              : Colors.blue, // Disable button if published
                        ),
                        child: Text(
                          isPublished ? "Results Published" : "Publish Results",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
