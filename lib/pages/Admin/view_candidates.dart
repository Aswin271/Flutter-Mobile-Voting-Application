import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewCandidates extends StatefulWidget {
  const ViewCandidates({super.key});

  @override
  State<ViewCandidates> createState() => _ViewCandidatesState();
}

class _ViewCandidatesState extends State<ViewCandidates> {
  List<Map<String, dynamic>> candidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Candidates").get();
      candidates = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching candidates: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View Candidates'),
        ),
        body: Center(
            child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    if (candidates.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View Candidates'),
        ),
        body: Center(
          child: Text(
            "No candidates found.",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Candidates'),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(candidate['name']),
              subtitle: Text(
                  'Party: ${candidate['party']}\nPosition: ${candidate['position']}\nYear: ${candidate['year']}'),
              leading: candidate['profileImage'] != null
                  ? Image.network(candidate['profileImage'],
                      width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.person, size: 50),
            ),
          );
        },
      ),
    );
  }
}
