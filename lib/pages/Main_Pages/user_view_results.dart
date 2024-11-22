import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserViewResults extends StatefulWidget {
  const UserViewResults({super.key});

  @override
  State<UserViewResults> createState() => _UserViewResultsState();
}

class _UserViewResultsState extends State<UserViewResults> {
  // Fetch only published elections from Firestore
  Stream<QuerySnapshot> _fetchPublishedElections() {
    return FirebaseFirestore.instance
        .collection('Elections')
        .where('isPublished', isEqualTo: true) // Only get published elections
        .snapshots();
  }

  // Fetch candidates and their votes for a specific election
  Future<List<Map<String, dynamic>>> _fetchCandidates(String electionId) async {
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('Candidates')
        .where('electionId', isEqualTo: electionId)
        .get();

    return candidatesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
        'party': doc['party'],
        'position': doc['position'],
        'department': doc['department'],
        'year': doc['year'],
        'votes': doc['votes'] ?? 0, // Default to 0 if votes field is missing
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Results"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchPublishedElections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading elections: ${snapshot.error}"));
          }
          final elections = snapshot.data?.docs;

          // Show message if no published elections are found
          if (elections == null || elections.isEmpty) {
            return const Center(
              child: Text(
                "Results will be published later.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Display published elections
          return ListView.separated(
            itemCount: elections.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final election = elections[index];

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
                      const SizedBox(height: 10),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchCandidates(election.id),
                        builder: (context, candidateSnapshot) {
                          if (candidateSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (candidateSnapshot.hasError) {
                            return Center(
                                child: Text(
                                    "Error loading candidates: ${candidateSnapshot.error}"));
                          }
                          final candidates = candidateSnapshot.data;

                          if (candidates == null || candidates.isEmpty) {
                            return const Center(
                                child: Text(
                                    "No candidates found for this election."));
                          }

                          return _buildCandidateList(candidates);
                        },
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

  // Widget to display a list of candidates
  Widget _buildCandidateList(List<Map<String, dynamic>> candidates) {
    return Column(
      children: candidates.map((candidate) {
        return ListTile(
          title: Text(candidate['name']),
          subtitle: Text(
            "Party: ${candidate['party']} - Position: ${candidate['position']} - Votes: ${candidate['votes']} - Year: ${candidate['year']} - Department: ${candidate['department']}",
          ),
        );
      }).toList(),
    );
  }
}
