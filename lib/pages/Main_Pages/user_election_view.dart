import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:online_voting_app/pages/Main_Pages/view_user_candidates.dart';

class UserElectionView extends StatefulWidget {
  const UserElectionView({super.key});

  @override
  State<UserElectionView> createState() => _UserElectionViewState();
}

class _UserElectionViewState extends State<UserElectionView> {
  // Fetch active elections from Firestore based on end time
  Stream<QuerySnapshot> _fetchActiveElections() {
    final now = DateTime.now();
    return FirebaseFirestore.instance
        .collection('Elections')
        .where('endTime', isGreaterThanOrEqualTo: now) // Only checking endTime
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Elections"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchActiveElections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final elections = snapshot.data?.docs;

          if (elections == null || elections.isEmpty) {
            return const Center(child: Text("No active elections found."));
          }

          return ListView.builder(
            itemCount: elections.length,
            itemBuilder: (context, index) {
              final election = elections[index];
              return ListTile(
                title: Text(election['name']),
                subtitle: Text(
                  "End: ${DateFormat('dd/MM/yyyy HH:mm').format((election['endTime'] as Timestamp).toDate())}",
                ),
                onTap: () {
                  // Navigate to ViewUserCandidates and pass the election ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewUserCandidates(electionId: election.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
