import 'package:flutter/material.dart';
import 'package:online_voting_app/service/database.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({super.key});

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    List<Map<String, dynamic>> studentList =
        await DatabaseMethods().getStudentDetails();
    setState(() {
      students = studentList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Students'),
      ),
      body: students.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student['name'] ?? 'No Name'),
                  subtitle:
                      Text('Roll Number: ${student['rollNumber'] ?? 'N/A'}'),
                  trailing: Text(student['department'] ?? 'N/A'),
                );
              },
            ),
    );
  }
}
