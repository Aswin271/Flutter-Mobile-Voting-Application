import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for the current user

class ViewUserCandidates extends StatefulWidget {
  final String electionId; // Accept election ID from the previous screen

  const ViewUserCandidates({super.key, required this.electionId});

  @override
  State<ViewUserCandidates> createState() => _ViewUserCandidatesState();
}

class _ViewUserCandidatesState extends State<ViewUserCandidates> {
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Current user ID

  // Fetch candidates for the specified election
  Future<List<Map<String, dynamic>>> _fetchCandidates() async {
    try {
      final candidatesSnapshot = await FirebaseFirestore.instance
          .collection('Candidates')
          .where('electionId', isEqualTo: widget.electionId)
          .get();

      return candidatesSnapshot.docs
          .map((doc) => {
                'id': doc.id, // Include the document ID for voting
                'name': doc['name'],
                'party': doc['party'], // Fetch party
                'position': doc['position'], // Fetch position
                'department': doc['department'], // Fetch department
                'year': doc['year'], // Fetch year
              })
          .toList();
    } catch (e) {
      // Handle any errors when fetching candidates
      print('Error fetching candidates: $e');
      return [];
    }
  }

  // Function to handle voting for a candidate
  Future<void> _voteForCandidate(String candidateId) async {
    try {
      // Fetch user data
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      // Check if the user has already voted in this election
      final hasVotedMap =
          userDoc.data()?['hasVoted'] as Map<String, dynamic>? ?? {};
      final bool hasVoted = hasVotedMap[widget.electionId] ?? false;

      if (hasVoted) {
        // If user has already voted, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have already voted in this election')),
        );
      } else {
        // If not voted, update the vote count for the candidate
        await FirebaseFirestore.instance
            .collection('Candidates')
            .doc(candidateId)
            .update({
          'votes': FieldValue.increment(1), // Increment the vote count
        });

        // Update the user's hasVoted status for this election
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'hasVoted.${widget.electionId}':
              true, // Mark the user as voted in this election
        });

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vote cast successfully!')),
        );
      }
    } catch (e) {
      // Handle any errors when voting
      print('Error casting vote: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while casting vote: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidates"),
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
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    child:
                        Icon(Icons.person), // Placeholder for the profile image
                  ),
                  title: Text(candidate['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Party: ${candidate['party']}"),
                      Text("Position: ${candidate['position']}"),
                      Text("Department: ${candidate['department']}"),
                      Text("Year: ${candidate['year']}"),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _voteForCandidate(candidate['id']),
                    child: const Text('Vote'),
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
