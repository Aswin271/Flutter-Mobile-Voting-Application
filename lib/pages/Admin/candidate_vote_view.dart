import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateVoteView extends StatelessWidget {
  final String electionId;

  const CandidateVoteView({Key? key, required this.electionId})
      : super(key: key);

  // Fetch candidates and their votes for a specific election
  Future<List<Map<String, dynamic>>> _fetchCandidates() async {
    final candidatesSnapshot = await FirebaseFirestore.instance
        .collection('Candidates')
        .where('electionId', isEqualTo: electionId)
        .get();

    return candidatesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] ?? 'Unknown', // Default name if missing
        'party': doc['party'] ?? 'Unknown', // Default party if missing
        'position': doc['position'] ?? 'Unknown', // Default position if missing
        'department':
            doc['department'] ?? 'Unknown', // Default department if missing
        'year': doc['year'] ?? 'Unknown', // Default year if missing
        'votes': doc.data().containsKey('votes')
            ? doc['votes']
            : 0, // Check if 'votes' exists
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidates and Votes"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCandidates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final candidates = snapshot.data;

          if (candidates == null || candidates.isEmpty) {
            return const Center(
                child: Text("No candidates found for this election."));
          }

          return ListView.builder(
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return ListTile(
                title: Text(candidate['name']),
                subtitle: Text(
                  "Party: ${candidate['party']} - Position: ${candidate['position']} - Votes: ${candidate['votes']} - Year: ${candidate['year']} - Department: ${candidate['department']}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
